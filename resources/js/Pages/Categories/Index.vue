<template>
  <layout title="Category List">
    <template #header>
      Categories
    </template>
    <table>
      <tbody>
        <tr v-for="category in categories" v-bind:key="category.id">
          <td>{{ category.name }}</td>
        </tr>
      </tbody>
    </table>
  </layout>
</template>

<script>
  import Layout from '../../Layout'

  export default {
    components: {
      Layout,
    },
    props: {
      categories: Array,
    },
  }
</script>