# Global settings
ARG PHP_VERSION=7.4
ARG NODE_VERSION=12
ARG NGINX_VERSION=1.17
ARG COMPOSER_VERSION=2

#
# Stage 1 - PHP Dependencies
#
FROM composer:${COMPOSER_VERSION} as vendor

WORKDIR /srv/laravelapp

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist


#
# Stage 2 - Build front end
#
FROM node:${NODE_VERSION}-alpine AS nodejs

WORKDIR /srv/laravelapp

COPY package.json yarn.lock webpack.mix.js ./
COPY resources/ ./resources/

RUN set -eux; \
    yarn install; \
    yarn cache clean;

RUN set -eux; \
	yarn run production


#
# Stage 3 - Build PHP server
#
FROM php:${PHP_VERSION}-fpm-alpine AS laravelapp_php

# persistent / runtime deps
RUN apk add --no-cache \
        acl \
        file \
        gettext \
        git \
    ;

RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        coreutils \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libtool \
        libwebp-dev \
        libzip-dev \
        mariadb-dev \
    ; \
    \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-webp=/usr/include --with-freetype=/usr/include/; \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        exif \
        gd \
        intl \
        pdo_mysql \
        zip \
    ; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-cache --virtual .laravelapp-phpexts-rundeps $runDeps; \
    \
    apk del .build-deps

COPY docker/php-fpm/php.ini /usr/local/etc/php/php.ini
COPY docker/php-fpm/php-cli.ini /usr/local/etc/php/php-cli.ini
COPY docker/php-fpm/zz-docker.conf /usr/local/etc/php-fpm.d/zzz-docker.conf

WORKDIR /srv/laravelapp

COPY . ./

COPY --from=vendor /srv/laravelapp/vendor/ ./vendor/

# build for production
ARG APP_ENV=production

RUN set -eux; \
    mkdir -p storage/logs storage/framework bootstrap/cache;

COPY docker/php-fpm/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Grab the compiled JS/CSS files
COPY --from=nodejs /srv/laravelapp/public public/
RUN ls /srv/laravelapp/public
RUN cat /srv/laravelapp/public/mix-manifest.json

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]

#
# Stage 4 - Build NGINX server
#
FROM nginx:${NGINX_VERSION}-alpine AS laravelapp_nginx

COPY docker/nginx/conf.d/default.conf /etc/nginx/conf.d/

WORKDIR /srv/laravelapp

COPY --from=laravelapp_php /srv/laravelapp/public public/