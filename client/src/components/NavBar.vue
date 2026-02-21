<template>
  <nav class="fixed top-0 left-0 right-0 z-40 bg-white/80 backdrop-blur-xl shadow-sm border-b border-gray-100/50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16 sm:h-18">
        <!-- Logo/Brand -->
        <div class="flex items-center space-x-3">
          <div class="relative">
            <div class="absolute -inset-1 bg-gradient-to-r from-main-blue to-main-green rounded-xl blur opacity-30"></div>
            <img src="/healthtrust-logo.png" alt="HealthTrust" class="relative w-9 h-9 sm:w-10 sm:h-10" />
          </div>
          <div>
            <h1 class="text-lg sm:text-xl font-extrabold bg-clip-text text-transparent bg-gradient-to-r from-main-blue to-main-green">HealthTrust</h1>
            <p class="text-[10px] sm:text-xs text-secondary-blue hidden sm:block tracking-wide">Decentralized Health Insurance</p>
          </div>
        </div>

        <!-- Network badge (desktop) -->
        <div class="hidden md:flex items-center space-x-2 px-3 py-1.5 bg-emerald-50 border border-emerald-200 rounded-full">
          <div class="w-2 h-2 rounded-full bg-success-green animate-pulse"></div>
          <span class="text-xs font-medium text-emerald-700">Preprod Testnet</span>
        </div>

        <!-- Wallet Selector -->
        <div class="flex-shrink-0">
          <WalletSelector
            @wallet-connected="$emit('wallet-connected', $event)"
            @wallet-disconnected="$emit('disconnect')"
          />
        </div>
      </div>
    </div>
  </nav>

  <!-- Spacer to prevent content from going under fixed navbar -->
  <div class="h-16 sm:h-18"></div>
</template>

<script setup>
import WalletSelector from './WalletSelector.vue';

defineEmits(['disconnect', 'wallet-connected']);
</script>

