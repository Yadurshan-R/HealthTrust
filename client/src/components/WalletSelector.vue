<template>
  <div>
    <!-- Connect Wallet Button -->
    <button
      v-if="!isConnected"
      @click="showWalletModal = true"
      class="px-6 py-3 rounded-lg bg-main-blue text-white hover:bg-accent-orange transition shadow-lg font-semibold flex items-center space-x-2"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
      </svg>
      <span>Connect Wallet</span>
    </button>

    <!-- Connected Wallet Info -->
    <div v-else class="flex items-center space-x-3">
      <div class="flex items-center space-x-2 bg-white px-4 py-2 rounded-lg shadow border-2 border-success-green">
        <div class="w-8 h-8 rounded-full bg-gradient-to-r from-success-green to-main-blue flex items-center justify-center">
          <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <div>
          <div class="text-xs text-dark-gray">{{ connectedWalletName }}</div>
          <div class="text-sm font-semibold text-success-green">
            Connected
          </div>
        </div>
      </div>
      <button
        @click="disconnect"
        class="px-4 py-2 rounded-lg border-2 border-red-500 text-red-500 hover:bg-red-50 transition text-sm font-medium"
      >
        Disconnect
      </button>
    </div>

    <!-- Wallet Selection Modal -->
    <BaseModal v-model="showWalletModal" title="Connect Your Wallet">
      <template #body>
        <div class="p-6">
          <p class="text-secondary-blue mb-6">Choose your preferred Cardano wallet to continue</p>

          <!-- Loading State -->
          <div v-if="isConnecting" class="flex flex-col items-center justify-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-4 border-accent-orange border-t-transparent mb-4"></div>
            <p class="text-secondary-blue font-semibold">Connecting to {{ connectingWallet }}...</p>
            <p class="text-sm text-dark-gray mt-2">Please approve the connection in your wallet</p>
          </div>

          <!-- Error State -->
          <div v-else-if="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-4">
            <div class="flex items-center">
              <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
              </svg>
              <span>{{ error }}</span>
            </div>
            <button
              @click="error = null"
              class="mt-2 text-sm underline hover:no-underline"
            >
              Try Again
            </button>
          </div>

          <!-- Wallet Option -->
          <div v-else class="flex justify-center">
            <button
              @click="connectWallet('lace')"
              :disabled="!laceWallet.available"
              class="group w-full max-w-sm bg-white border-2 border-gray-200 rounded-2xl p-6 transition-all duration-300 hover:border-main-blue hover:shadow-xl hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 disabled:hover:shadow-none"
            >
              <div class="flex items-center space-x-5">
                <!-- Wallet Logo - Interactive with animated ring -->
                <div class="relative w-16 h-16 flex-shrink-0">
                  <!-- Animated gradient ring -->
                  <div class="absolute inset-0 rounded-full bg-gradient-to-r from-[#7b61ff] via-[#e84393] to-[#7b61ff] opacity-0 group-hover:opacity-100 group-hover:animate-spin-slow blur-sm transition-opacity duration-500" style="animation-duration: 3s;"></div>
                  <!-- Inner container -->
                  <div class="relative w-full h-full rounded-full bg-white border-2 border-gray-200 group-hover:border-transparent flex items-center justify-center overflow-hidden group-hover:shadow-[0_0_20px_rgba(123,97,255,0.35)] group-hover:scale-110 transition-all duration-300">
                    <img 
                      :src="laceWallet.icon" 
                      :alt="laceWallet.name"
                      class="w-12 h-12 rounded-full object-cover group-hover:scale-110 transition-transform duration-300"
                    />
                  </div>
                </div>
                
                <!-- Wallet Info -->
                <div class="flex-1 text-left">
                  <div class="text-lg font-bold text-gray-900 group-hover:text-main-blue transition">
                    Lace Wallet
                  </div>
                  <div class="text-sm text-gray-500 mt-0.5">
                    {{ laceWallet.available ? 'Click to connect' : 'Extension not detected' }}
                  </div>
                </div>

                <!-- Arrow -->
                <div class="flex-shrink-0 text-gray-300 group-hover:text-main-blue group-hover:translate-x-1 transition-all duration-300">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                  </svg>
                </div>
              </div>
            </button>
          </div>

          <!-- Help Text -->
          <div class="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
            <div class="flex items-start">
              <svg class="w-5 h-5 text-main-blue mt-1 mr-3 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
              </svg>
              <div class="text-sm text-blue-700">
                <strong>Don't have Lace Wallet?</strong>
                <p class="mt-1">
                  Download and install the Lace browser extension to get started:
                </p>
                <a href="https://www.lace.io" target="_blank" class="inline-block mt-2 underline hover:no-underline font-medium">
                  www.lace.io →
                </a>
              </div>
            </div>
          </div>
        </div>
      </template>
    </BaseModal>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import BaseModal from './BaseModal.vue';
import { useToast } from '../composables/useToast';

const emit = defineEmits(['wallet-connected', 'wallet-disconnected']);

const { showSuccess, showError } = useToast();

// State
const showWalletModal = ref(false);
const isConnected = ref(false);
const isConnecting = ref(false);
const walletAddress = ref('');
const connectedWalletName = ref('');
const connectingWallet = ref('');
const error = ref(null);

// Lace Wallet Configuration
const laceWallet = ref({
  key: 'lace',
  name: 'Lace',
  icon: '/lace-icon-new.png',
  color: 'rgba(236, 72, 153, 0.15)',
  textColor: '#db2777',
  available: false
});

// Handle image loading errors (fallback to first letter if image fails)
const handleImageError = (event) => {
  console.warn('Failed to load wallet icon, using fallback');
  // Could add fallback logic here if needed
};

// Methods
const checkWalletAvailability = () => {
  if (typeof window === 'undefined' || !window.cardano) {
    console.log('⏳ Cardano API not ready yet');
    return;
  }
  
  const isAvailable = !!window.cardano['lace'];
  laceWallet.value.available = isAvailable;
  if (isAvailable) {
    console.log('✅ Lace wallet detected');
  }
};

// Poll for wallet availability - fixes race condition
const pollForWallets = () => {
  let attempts = 0;
  const maxAttempts = 5; // Reduced from 10
  
  const interval = setInterval(() => {
    attempts++;
    checkWalletAvailability();
    
    // Check if we found the wallet
    if (laceWallet.value.available || attempts >= maxAttempts) {
      clearInterval(interval);
      if (laceWallet.value.available) {
        console.log('✅ Wallet polling complete - Lace found');
      } else {
        console.log('⚠️ Lace wallet not detected after polling');
      }
    }
  }, 300);
};

const connectWallet = async (walletKey) => {
  // Double-check wallet is available
  if (!window.cardano || !window.cardano[walletKey]) {
    error.value = 'Lace wallet not found. Please make sure the extension is installed and enabled.';
    showError(error.value);
    return;
  }

  isConnecting.value = true;
  connectingWallet.value = 'Lace';
  error.value = null;

  try {
    console.log('🔌 Attempting to connect to Lace...');
    
    // Check if wallet API is ready
    if (!window.cardano[walletKey].enable) {
      throw new Error('Wallet API not ready. Please refresh and try again.');
    }

    // Enable the wallet with 30 second timeout
    const walletAPI = await Promise.race([
      window.cardano[walletKey].enable(),
      new Promise((_, reject) => 
        setTimeout(() => reject(new Error('Connection timeout - please try again')), 30000)
      )
    ]);
    
    console.log(`✅ Lace API enabled`);

    // Get network ID
    const networkId = await walletAPI.getNetworkId();
    console.log('📡 Network ID:', networkId);

    // Verify we're on testnet (networkId 0 = preprod, 1 = mainnet)
    if (networkId === 1) {
      console.warn('⚠️ Connected to mainnet - application expects testnet');
    }

    // Get addresses - wallet APIs return hex-encoded addresses
    // Try getUsedAddresses first, fall back to getUnusedAddresses for new wallets
    let addressesHex = await walletAPI.getUsedAddresses();
    if (!addressesHex || addressesHex.length === 0) {
      console.log('⚠️ No used addresses, trying unused addresses (new wallet)...');
      addressesHex = await walletAPI.getUnusedAddresses();
    }
    if (!addressesHex || addressesHex.length === 0) {
      throw new Error('No addresses found in wallet. Please create an account in your wallet extension first.');
    }
    
    const rawHex = addressesHex[0];
    console.log('🔍 Raw address from wallet:', rawHex);
    
    // Convert hex address to bech32 format
    // CIP-30 wallets return addresses as hex-encoded bytes
    let address;
    
    // Check if it's already bech32 (starts with addr)
    if (rawHex.startsWith('addr')) {
      address = rawHex;
      console.log('✅ Address already in bech32 format:', address);
    } else {
      try {
        // Convert hex string to Uint8Array (browser-safe, no Buffer needed)
        const hexBytes = new Uint8Array(
          rawHex.match(/.{1,2}/g).map(byte => parseInt(byte, 16))
        );

        // Determine prefix from the header byte
        // Bits 0-3 of first byte: 0 = testnet, 1 = mainnet
        const prefix = (hexBytes[0] & 0x0F) === 0 ? 'addr_test' : 'addr';

        // Use the bech32 library (transitive dep of MeshSDK)
        const { bech32 } = await import('bech32');
        const words = bech32.toWords(hexBytes);
        address = bech32.encode(prefix, words, 200);

        console.log('✅ Converted hex → bech32:', address);
      } catch (conversionError) {
        console.error('❌ Bech32 conversion failed:', conversionError);
        // Absolute last resort — should not happen
        address = rawHex;
      }
    }

    // Store connection info
    walletAddress.value = address;
    connectedWalletName.value = 'Lace';
    isConnected.value = true;

    // Store in localStorage for persistence
    localStorage.setItem('connectedWallet', walletKey);
    localStorage.setItem('walletAddress', address);
    localStorage.setItem('walletName', 'Lace');

    // Close modal
    showWalletModal.value = false;

    // Emit event
    emit('wallet-connected', { wallet: walletAPI, address, name: 'Lace' });
    showSuccess('Connected to Lace successfully!');

    console.log('✅ Successfully connected to Lace');
    console.log('📍 Address:', address);

  } catch (err) {
    console.error('❌ Wallet connection error:', err);
    
    // Provide specific error messages
    let errorMessage = 'Failed to connect to wallet.';
    
    if (err.message.includes('timeout')) {
      errorMessage = 'Connection timeout after 30 seconds. Please:\n1. Make sure Lace extension is unlocked\n2. Click the Lace extension icon in your browser\n3. Approve the connection request\n4. Then try connecting again';
    } else if (err.message.includes('User rejected') || err.message.includes('user rejected')) {
      errorMessage = 'Connection rejected. Please approve the connection in your wallet.';
    } else if (err.message.includes('not ready')) {
      errorMessage = err.message;
    } else {
      errorMessage = err.message || 'Failed to connect to Lace. Please ensure the wallet is unlocked and try again.';
    }
    
    error.value = errorMessage;
    showError(errorMessage);
  } finally {
    isConnecting.value = false;
    connectingWallet.value = '';
  }
};

const disconnect = () => {
  walletAddress.value = '';
  connectedWalletName.value = '';
  isConnected.value = false;

  // Clear localStorage
  localStorage.removeItem('connectedWallet');
  localStorage.removeItem('walletAddress');
  localStorage.removeItem('walletName');

  emit('wallet-disconnected');
  showSuccess('Wallet disconnected');
  console.log('🔌 Wallet disconnected');
};

const truncateAddress = (address) => {
  if (!address) return '';
  return `${address.substring(0, 8)}...${address.substring(address.length - 8)}`;
};

const tryReconnect = async () => {
  const savedWallet = localStorage.getItem('connectedWallet');
  const savedAddress = localStorage.getItem('walletAddress');
  const savedName = localStorage.getItem('walletName');

  if (savedWallet && savedAddress) {
    // Wait a bit for cardano object to be available
    await new Promise(resolve => setTimeout(resolve, 500));
    
    if (window.cardano && window.cardano[savedWallet]) {
      try {
        console.log(`🔄 Attempting auto-reconnect to ${savedWallet}...`);
        
        // Just restore the saved state without calling enable again
        walletAddress.value = savedAddress;
        connectedWalletName.value = savedName || savedWallet;
        isConnected.value = true;
        
        // Emit event so App.vue fetches user data and shows profile modal if needed
        emit('wallet-connected', { wallet: null, address: savedAddress, name: savedName || savedWallet });
        
        console.log(`✅ Auto-reconnected to ${savedWallet}`);
      } catch (err) {
        console.log('❌ Auto-reconnect failed:', err.message);
        // If reconnection fails, clear saved data
        localStorage.removeItem('connectedWallet');
        localStorage.removeItem('walletAddress');
        localStorage.removeItem('walletName');
      }
    }
  }
};

// Lifecycle
onMounted(() => {
  console.log('🚀 WalletSelector mounted');
  
  // Initial check
  checkWalletAvailability();
  
  // Start polling for wallets (handles race conditions)
  pollForWallets();
  
  // Try to reconnect if previously connected
  tryReconnect();

  // Listen for account changes
  if (window.cardano) {
    Object.keys(window.cardano).forEach(walletKey => {
      const wallet = window.cardano[walletKey];
      if (wallet && typeof wallet.on === 'function') {
        wallet.on('accountChange', () => {
          console.log('👤 Account changed, disconnecting...');
          disconnect();
        });
      }
    });
  }
});

// Expose disconnect method
defineExpose({
  disconnect,
});
</script>

<style scoped>
.animate-spin {
  animation: spin 1s linear infinite;
}

.animate-spin-slow {
  animation: spin 3s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
