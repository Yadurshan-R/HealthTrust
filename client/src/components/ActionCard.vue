<template>
  <div
    class="bg-white rounded-2xl shadow-sm hover:shadow-lg transition-all duration-300 cursor-pointer border border-gray-100 overflow-hidden group"
    @click="$emit('click')"
  >
    <!-- Top accent bar -->
    <div class="h-1" :class="accentBarClass"></div>
    
    <div class="p-5 sm:p-6">
      <!-- Icon -->
      <div class="flex justify-center mb-4">
        <div
          class="w-14 h-14 rounded-2xl flex items-center justify-center transition-transform duration-300 group-hover:scale-110"
          :class="iconBgClass"
        >
          <component
            :is="iconComponent"
            class="w-7 h-7"
            :class="iconColorClass"
          />
        </div>
      </div>

      <!-- Title -->
      <h3 class="text-base sm:text-lg font-bold text-center text-gray-900 mb-1.5">
        {{ title }}
      </h3>

      <!-- Description -->
      <p class="text-xs sm:text-sm text-secondary-blue text-center mb-4 leading-relaxed">
        {{ description }}
      </p>

      <!-- Custom Content Slot -->
      <div v-if="$slots.content" class="mt-4">
        <slot name="content"></slot>
      </div>

      <!-- Actions Slot -->
      <div v-if="$slots.actions" class="mt-5 flex justify-center gap-3">
        <slot name="actions"></slot>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import {
  CloudArrowUpIcon,
  EyeIcon,
  ArrowPathIcon,
  CheckCircleIcon,
  ClipboardDocumentListIcon,
} from '@heroicons/vue/24/outline';

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    default: '',
  },
  icon: {
    type: String,
    default: 'clipboard',
    validator: (value) => ['upload', 'view', 'transfer', 'check', 'clipboard'].includes(value),
  },
  variant: {
    type: String,
    default: 'primary',
    validator: (value) => ['primary', 'success', 'info', 'warning'].includes(value),
  },
});

defineEmits(['click']);

const iconComponent = computed(() => {
  const icons = {
    upload: CloudArrowUpIcon,
    view: EyeIcon,
    transfer: ArrowPathIcon,
    check: CheckCircleIcon,
    clipboard: ClipboardDocumentListIcon,
  };
  return icons[props.icon] || ClipboardDocumentListIcon;
});

const borderColorClass = computed(() => {
  const colors = {
    primary: 'border-main-blue',
    success: 'border-main-green',
    info: 'border-accent-orange',
    warning: 'border-warning-yellow',
  };
  return colors[props.variant] || 'border-main-blue';
});

const accentBarClass = computed(() => {
  const colors = {
    primary: 'bg-gradient-to-r from-main-blue to-main-blue/60',
    success: 'bg-gradient-to-r from-main-green to-main-green/60',
    info: 'bg-gradient-to-r from-accent-orange to-accent-orange/60',
    warning: 'bg-gradient-to-r from-warning-yellow to-warning-yellow/60',
  };
  return colors[props.variant] || 'bg-gradient-to-r from-main-blue to-main-blue/60';
});

const iconBgClass = computed(() => {
  const colors = {
    primary: 'bg-blue-100',
    success: 'bg-green-100',
    info: 'bg-orange-100',
    warning: 'bg-yellow-100',
  };
  return colors[props.variant] || 'bg-blue-100';
});

const iconColorClass = computed(() => {
  const colors = {
    primary: 'text-main-blue',
    success: 'text-main-green',
    info: 'text-accent-orange',
    warning: 'text-warning-yellow',
  };
  return colors[props.variant] || 'text-main-blue';
});
</script>
