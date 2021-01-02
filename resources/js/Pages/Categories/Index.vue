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
            <th class="font-bold p-2 text-left"></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="category in categories" v-bind:key="category.id">
            <td class="p-2 border-gray-300 border-t">{{ category.name }}</td>
            <td class="p-2 border-gray-300 border-t">
              <button class="rounded-md border border-gray-300 px-4 py-2 cursor-pointer bg-blue-700 hover:bg-blue-400 text-gray-200 shadow-sm hover:text-gray-800 focus:outline-none focus:shadow-outline-blue transition ease-in-out duration-150" @click="showCategoryModal(category)">Edit</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <category-modal v-bind:category="categoryBeingEdited"></category-modal>
  </layout>
</template>

<script>
  import Layout from '../../Layout';
  import CategoryModal from '../../components/modals/CategoryModal';

  export default {
    components: {
      Layout,
      CategoryModal,
    },
    props: {
      categories: Array,
    },
    data() {
      return {
        categoryBeingEdited: null
      }
    },
    methods: {
      showCategoryModal (category) {
        this.categoryBeingEdited = category;
      },
      deleteRow: function (data) {
        if (!confirm('Are you sure want to remove?')) return;
        data._method = 'DELETE';
        this.$inertia.post('/categories/' + data.id, data)
        this.reset();
        this.closeModal();
      }
    }
  }
</script>