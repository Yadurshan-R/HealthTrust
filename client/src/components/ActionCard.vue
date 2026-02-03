<template>
  <div
    class="bg-white rounded-2xl shadow-card hover:shadow-card-hover transition-all duration-300 cursor-pointer border-t-4 p-6"
    :class="borderColorClass"
    @click="$emit('click')"
  >
    <!-- Icon -->
    <div class="flex justify-center mb-4">
      <div
        class="w-16 h-16 rounded-full flex items-center justify-center shadow-md"
        :class="iconBgClass"
      >
        <component
          :is="iconComponent"
          class="w-8 h-8"
          :class="iconColorClass"
        />
      </div>
    </div>

    <!-- Title -->
    <h3 class="text-lg font-semibold text-center text-main-blue mb-2">
      {{ title }}
    </h3>

    <!-- Description -->
    <p class="text-sm text-secondary-blue text-center mb-4">
      {{ description }}
    </p>

    <!-- Custom Content Slot -->
    <div v-if="$slots.content" class="mt-4">
      <slot name="content"></slot>
    </div>

    <!-- Actions Slot -->
    <div v-if="$slots.actions" class="mt-6 flex justify-center gap-3">
      <slot name="actions"></slot>
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
