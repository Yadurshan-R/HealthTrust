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

          <!-- Wallet Options - Horizontal layout (3 across) -->
          <div v-else class="grid grid-cols-3 gap-4">
            <button
              v-for="wallet in supportedWallets"
              :key="wallet.key"
              @click="connectWallet(wallet.key)"
              :disabled="!wallet.available"
              class="wallet-card group"
              :class="wallet.available ? 'hover:border-accent-orange hover:bg-orange-50' : 'opacity-50 cursor-not-allowed'"
            >
              <div class="flex flex-col items-center text-center space-y-3">
                <!-- Wallet Logo -->
                <div class="wallet-icon" :style="{ backgroundColor: wallet.color }">
                  <img 
                    :src="wallet.icon" 
                    :alt="wallet.name"
                    class="w-8 h-8 object-contain"
                    @error="handleImageError"
                  />
                </div>
                
                <!-- Wallet Info -->
                <div>
                  <div class="font-semibold text-main-blue group-hover:text-accent-orange transition">
                    {{ wallet.name }}
                  </div>
                  <div class="text-xs text-dark-gray mt-1">
                    {{ wallet.available ? 'Click to connect' : 'Not installed' }}
                  </div>
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
                <strong>New to Cardano wallets?</strong>
                <p class="mt-1">
                  Download and install a wallet extension:
                </p>
                <ul class="mt-2 space-y-1">
                  <li>
                    <a href="https://namiwallet.io" target="_blank" class="underline hover:no-underline font-medium">
                      Nami Wallet
                    </a>
                  </li>
                  <li>
                    <a href="https://eternl.io" target="_blank" class="underline hover:no-underline font-medium">
                      Eternl Wallet
                    </a>
                  </li>
                  <li>
                    <a href="https://www.lace.io" target="_blank" class="underline hover:no-underline font-medium">
                      Lace Wallet
                    </a>
                  </li>
                </ul>
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

// Supported Wallets Configuration - Nami, Eternl, Lace
const supportedWallets = ref([
  {
    key: 'nami',
    name: 'Nami',
    icon: '/nami-icon.png',
    color: 'rgba(147, 51, 234, 0.15)',
    textColor: '#7c3aed',
    available: false
  },
  {
    key: 'eternl',
    name: 'Eternl',
    icon: '/eternl-icon-new.png',
    color: 'rgba(59, 130, 246, 0.15)',
    textColor: '#2563eb',
    available: false
  },
  {
    key: 'lace',
    name: 'Lace',
    icon: '/lace-icon-new.png',
    color: 'rgba(236, 72, 153, 0.15)',
    textColor: '#db2777',
    available: false
  }
]);

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
  
  supportedWallets.value.forEach(wallet => {
    const isAvailable = !!window.cardano[wallet.key];
    wallet.available = isAvailable;
    if (isAvailable) {
      console.log(`✅ ${wallet.name} wallet detected`);
    }
  });
};

// Poll for wallet availability - fixes race condition
const pollForWallets = () => {
  let attempts = 0;
  const maxAttempts = 5; // Reduced from 10
  
  const interval = setInterval(() => {
    attempts++;
    checkWalletAvailability();
    
    // Check if we found any wallets
    const hasWallets = supportedWallets.value.some(w => w.available);
    
    if (hasWallets || attempts >= maxAttempts) {
      clearInterval(interval);
      if (hasWallets) {
        console.log('✅ Wallet polling complete - wallets found');
      } else {
        console.log('⚠️ No wallets detected after polling');
      }
    }
  }, 300); // Increased from 200ms to 300ms - less aggressive polling
};

const connectWallet = async (walletKey) => {
  // Double-check wallet is available
  if (!window.cardano || !window.cardano[walletKey]) {
    error.value = `${walletKey} wallet not found. Please make sure the extension is installed and enabled.`;
    showError(error.value);
    return;
  }

  const selectedWallet = supportedWallets.value.find(w => w.key === walletKey);
  if (!selectedWallet) return;

  isConnecting.value = true;
  connectingWallet.value = selectedWallet.name;
  error.value = null;

  try {
    console.log(`🔌 Attempting to connect to ${selectedWallet.name}...`);
    
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
    
    console.log(`✅ ${selectedWallet.name} API enabled`);

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
    connectedWalletName.value = selectedWallet.name;
    isConnected.value = true;

    // Store in localStorage for persistence
    localStorage.setItem('connectedWallet', walletKey);
    localStorage.setItem('walletAddress', address);
    localStorage.setItem('walletName', selectedWallet.name);

    // Close modal
    showWalletModal.value = false;

    // Emit event
    emit('wallet-connected', { wallet: walletAPI, address, name: selectedWallet.name });
    showSuccess(`✅ Connected to ${selectedWallet.name} successfully!`);

    console.log(`✅ Successfully connected to ${selectedWallet.name}`);
    console.log('📍 Address:', address);

  } catch (err) {
    console.error('❌ Wallet connection error:', err);
    
    // Provide specific error messages
    let errorMessage = 'Failed to connect to wallet.';
    
    if (err.message.includes('timeout')) {
      errorMessage = `Connection timeout after 30 seconds. Please:\n1. Make sure ${selectedWallet.name} extension is unlocked\n2. Click the ${selectedWallet.name} extension icon in your browser\n3. Approve the connection request\n4. Then try connecting again`;
    } else if (err.message.includes('User rejected') || err.message.includes('user rejected')) {
      errorMessage = 'Connection rejected. Please approve the connection in your wallet.';
    } else if (err.message.includes('not ready')) {
      errorMessage = err.message;
    } else {
      errorMessage = err.message || `Failed to connect to ${selectedWallet.name}. Please ensure the wallet is unlocked and try again.`;
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
.wallet-card {
  @apply bg-white border-2 border-gray-200 rounded-xl p-4 transition-all duration-200;
}

.wallet-card:hover:not(:disabled) {
  @apply shadow-lg transform scale-105;
}

.wallet-icon {
  @apply w-10 h-10 rounded-full flex items-center justify-center;
}

.animate-spin {
  animation: spin 1s linear infinite;
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
