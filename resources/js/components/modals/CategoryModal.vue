<template>
  <edit-form-modal v-model="form">
    <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
      <div class="mb-4">
        <label for="categoryName" class="block text-gray-700 text-sm font-bold mb-2">Category Name:</label>
        <input type="text" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" id="categoryName" placeholder="Enter Category Name" v-model="form.name">
        <!-- <div v-if="errors.name" class="text-red-500">{{ errors.name[0] }}</div> -->
      </div>
    </div>
  </edit-form-modal>
</template>

<script>
import EditFormModal from './EditFormModal';
export default {
  components: {
    EditFormModal
  },
  props: {
    category: {
      required: true
    }
  },
  data() {
    return {
      form: {},
    }
  },
  watch: {
    category(newValue) {
      this.form = Object.assign({}, newValue);
    }
  }
}
</script>