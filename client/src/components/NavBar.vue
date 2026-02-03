<template>
  <nav class="fixed top-0 left-0 right-0 z-40 bg-white shadow-md">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <!-- Logo/Brand -->
        <div class="flex items-center space-x-3">
          <img src="/healthtrust-logo.png" alt="HealthTrust" class="w-10 h-10" />
          <div>
            <h1 class="text-xl font-bold text-main-blue">HealthTrust</h1>
            <p class="text-xs text-secondary-blue hidden sm:block">Decentralized Health Insurance</p>
          </div>
        </div>

        <!-- Wallet Selector -->
        <div>
          <WalletSelector
            @wallet-connected="$emit('wallet-connected', $event)"
            @wallet-disconnected="$emit('disconnect')"
          />
        </div>
      </div>
    </div>
  </nav>

  <!-- Spacer to prevent content from going under fixed navbar -->
  <div class="h-16"></div>
</template>

<script setup>
import WalletSelector from './WalletSelector.vue';

defineEmits(['disconnect', 'wallet-connected']);
</script>

