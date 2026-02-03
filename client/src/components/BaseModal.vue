<template>
  <Teleport to="body">
    <Transition name="fade">
      <div
        v-if="modelValue"
        class="fixed inset-0 z-[1000] flex items-center justify-center p-4 bg-black/70"
        @click.self="closeModal"
      >
        <div
          class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col animate-in slide-in-from-bottom-4 duration-300"
        >
          <!-- Header -->
          <div class="bg-gradient-to-r from-main-blue to-accent-orange p-6 text-white flex items-center justify-between">
            <slot name="title">
              <h2 class="text-2xl font-bold">{{ title }}</h2>
            </slot>
            <button
              @click="closeModal"
              class="text-white hover:bg-white/20 rounded-full p-2 transition-colors"
              aria-label="Close modal"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <!-- Body -->
          <div class="flex-1 overflow-y-auto p-6 scrollbar-thin">
            <slot name="body"></slot>
          </div>

          <!-- Footer (optional) -->
          <div v-if="$slots.footer" class="border-t border-gray-200 p-6 bg-gray-50">
            <slot name="footer"></slot>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { watch } from 'vue';

const props = defineProps({
  modelValue: {
    type: Boolean,
    required: true,
  },
  title: {
    type: String,
    default: '',
  },
});

const emit = defineEmits(['update:modelValue']);

const closeModal = () => {
  emit('update:modelValue', false);
};

// Prevent body scroll when modal is open
watch(() => props.modelValue, (isOpen) => {
  if (isOpen) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.animate-in {
  animation-name: slideIn;
  animation-duration: 0.3s;
  animation-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes slideIn {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.slide-in-from-bottom-4 {
  animation-name: slideIn;
}
</style>
