<template>
  <layout title="Category List">
    <template #header>
      Categories
    </template>
    <div class="p-4 w-full md:w-5/12">
      <table class="border-collapse border border-gray-300 table-auto w-full list-table">
        <thead>
          <tr>
            <th class="font-bold p-2 text-left">Category Name</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="category in categories" v-bind:key="category.id">
            <td class="p-2 border-gray-300 border-t">{{ category.name }}</td>
          </tr>
        </tbody>
      </table>
    </div>
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