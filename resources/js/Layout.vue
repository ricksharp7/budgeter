<template>
  <div>
    <header class="p-4">
        <div class="text-3xl">
            <slot name="header"></slot>
        </div>
    </header>

    <!-- Page Content -->
    <main>
        <slot></slot>
    </main>
  </div>
</template>

<script>
  export default {
    props: {
      title: String,
    },
    watch: {
      title: {
        immediate: true,
        handler(title) {
          document.title = `${title} | Budgeter`;
        },
      },
    },
  }
</script>