<template>
  <transition
    enter-active-class="transition-all transition-fastest ease-out-quad"
    leave-active-class="transition-all transition-faster ease-in-quad"
    enter-class="opacity-0 scale-50"
    enter-to-class="opacity-100 scale-100"
    leave-class="opacity-100 scale-100"
    leave-to-class="opacity-0 scale-50"
    >
    <div class="fixed z-10 inset-0 overflow-y-auto" v-if="isOpen">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        
        <div class="fixed inset-0">
          <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
        </div>​
        <div class="origin-top-right absolute right-1/2 transform translate-x-1/2 mt-2 w-64 align-bottom bg-white rounded-lg text-left overflow-auto shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
          <form>
            <slot></slot>
            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
              <span class="flex w-full rounded-md shadow-sm sm:ml-3 sm:w-auto">
                <button type="button" class="inline-flex justify-center w-full rounded-md border border-transparent px-4 py-2 bg-green-600 text-base leading-6 font-medium text-white shadow-sm hover:bg-green-500 focus:outline-none focus:border-green-700 focus:shadow-outline-green transition ease-in-out duration-150 sm:text-sm sm:leading-5" @click="save()">
                  Save
                </button>
              </span>
              <span class="mt-3 flex w-full rounded-md shadow-sm sm:mt-0 sm:w-auto">
                <button @click="closeModal()" type="button" class="inline-flex justify-center w-full rounded-md border border-gray-300 px-4 py-2 bg-white text-base leading-6 font-medium text-gray-700 shadow-sm hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue transition ease-in-out duration-150 sm:text-sm sm:leading-5">
                  Cancel
                </button>
              </span>
            </div>
          </form>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    value: {
      required: true
    },
    resource: {
      type: String,
      required: true,
    }
  },
  data() {
    return {
      form: this.value,
      isOpen: false
    };
  },
  computed: {
    formData() {
      return this.value ?? {}
    },
    isEditing() {
      return this.form?.id > 0;
    },
    isProcessing() {
      return this.form?.processing ?? false;
    }
  },
  methods: {
    closeModal: function () {
      this.$emit('close');
      this.isOpen = false;
    },
    openModal: function () {
      this.isOpen = true;
    },
    save: function () {
      this.form.clearErrors();
      this.form.submit(
        (this.isEditing ? 'patch' : 'post'),
        `/${this.resource}/${this.form.id}`,
        {
          onSuccess: (page) => this.closeModal()
        }
      );
    }
  },
  watch: {
    value: {
      handler: function(newValue) {// Must use function to preserve "this"
        this.form = newValue;
        newValue && Object.keys(newValue).length ? this.openModal(newValue) : this.closeModal();
        this.$emit('input', this.value);
      },
      deep: true
    }
  }
}
</script>