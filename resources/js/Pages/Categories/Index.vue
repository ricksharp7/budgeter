<template>
  <div>
    <div v-for="category in categories" v-bind:key="category.id">
      {{ category.name }}
    </div>
  </div>
</template>

<script>

  export default {
    props: {
      categories: Array,
    },
  }
</script>