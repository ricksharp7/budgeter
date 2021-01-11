<template>
  <edit-form-modal v-model="form" resource="categories" @close="resetForm">
    <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
      <div class="mb-4">
        <label for="categoryName" class="block text-gray-700 text-sm font-bold mb-2">Category Name:</label>
        <input type="text" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" id="categoryName" placeholder="Enter Category Name" v-model="form.name">
        <div v-if="validationErrors.name" class="text-red-500">{{ validationErrors.name }}</div>
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
      form: {}
    }
  },
  computed: {
    validationErrors() {
      return {
        name: this.form?.errors?.name
      };
    }
  },
  methods: {
    resetForm() {
      this.form = {};
    }
  },
  watch: {
    category(newValue) {
      if (newValue) {
        this.form = this.$inertia.form(Object.assign({}, newValue));
      } else {
        this.form = {}
      }
    }
  }
}
</script>