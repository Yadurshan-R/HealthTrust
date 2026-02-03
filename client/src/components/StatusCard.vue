<template>
  <div
    class="bg-white rounded-2xl shadow-card p-6 border-l-4 transition-all duration-300"
    :class="[borderColorClass, clickable ? 'hover:shadow-card-hover cursor-pointer' : '']"
    @click="handleClick"
  >
    <div class="flex items-start justify-between">
      <div class="flex-1">
        <!-- Title -->
        <h4 class="text-sm font-medium text-secondary-blue mb-2">{{ title }}</h4>
        
        <!-- Count -->
        <div class="text-4xl font-bold mb-1" :class="countColorClass">
          {{ count }}
        </div>
        
        <!-- Description -->
        <p v-if="description" class="text-xs text-dark-gray">
          {{ description }}
        </p>
      </div>

      <!-- Icon Badge -->
      <div
        class="w-12 h-12 rounded-full flex items-center justify-center shadow-md"
        :class="iconBgClass"
      >
        <component
          :is="iconComponent"
          class="w-6 h-6"
          :class="iconColorClass"
        />
      </div>
    </div>

    <!-- Tooltip (optional) -->
    <div v-if="tooltip" class="mt-4 text-sm text-dark-gray flex items-center">
      <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
      </svg>
      {{ tooltip }}
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import {
  CheckCircleIcon,
  ExclamationCircleIcon,
  XCircleIcon,
  ClockIcon,
  DocumentTextIcon,
} from '@heroicons/vue/24/outline';

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  count: {
    type: [Number, String],
    required: true,
  },
  description: {
    type: String,
    default: '',
  },
  tooltip: {
    type: String,
    default: '',
  },
  icon: {
    type: String,
    default: 'document',
    validator: (value) => ['check', 'warning', 'error', 'clock', 'document'].includes(value),
  },
  variant: {
    type: String,
    default: 'info',
    validator: (value) => ['success', 'warning', 'danger', 'info', 'primary'].includes(value),
  },
  clickable: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(['click']);

const iconComponent = computed(() => {
  const icons = {
    check: CheckCircleIcon,
    warning: ExclamationCircleIcon,
    error: XCircleIcon,
    clock: ClockIcon,
    document: DocumentTextIcon,
  };
  return icons[props.icon] || DocumentTextIcon;
});

const borderColorClass = computed(() => {
  const colors = {
    success: 'border-success-green',
    warning: 'border-warning-yellow',
    danger: 'border-danger-red',
    info: 'border-main-blue',
    primary: 'border-accent-orange',
  };
  return colors[props.variant] || 'border-main-blue';
});

const countColorClass = computed(() => {
  const colors = {
    success: 'text-success-green',
    warning: 'text-warning-yellow',
    danger: 'text-danger-red',
    info: 'text-main-blue',
    primary: 'text-accent-orange',
  };
  return colors[props.variant] || 'text-main-blue';
});

const iconBgClass = computed(() => {
  const colors = {
    success: 'bg-green-100',
    warning: 'bg-yellow-100',
    danger: 'bg-red-100',
    info: 'bg-blue-100',
    primary: 'bg-orange-100',
  };
  return colors[props.variant] || 'bg-blue-100';
});

const iconColorClass = computed(() => {
  const colors = {
    success: 'text-success-green',
    warning: 'text-warning-yellow',
    danger: 'text-danger-red',
    info: 'text-main-blue',
    primary: 'text-accent-orange',
  };
  return colors[props.variant] || 'text-main-blue';
});

const handleClick = () => {
  if (props.clickable) {
    emit('click');
  }
};
</script>
