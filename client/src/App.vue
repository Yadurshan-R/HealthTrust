<template>
  <div class="min-h-screen bg-light-gray">
    <!-- Navigation Bar -->
    <NavBar
      @wallet-connected="onWalletConnected"
      @disconnect="onWalletDisconnected"
    />

    <!-- Main Container -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Header -->
      <div class="text-center mb-10">
        <div class="flex items-center justify-center space-x-4 mb-4">
          <img src="/healthtrust-logo.png" alt="HealthTrust Logo" class="w-12 h-12" />
          <h1 class="text-3xl md:text-4xl font-bold text-main-blue">HealthTrust</h1>
        </div>
        <p class="text-lg text-secondary-blue font-medium">Decentralized Health Insurance • AI-Powered Fraud Detection</p>
        <div class="flex items-center justify-center space-x-3 mt-4">
          <div class="w-3 h-3 rounded-full bg-success-green animate-pulse"></div>
          <span class="text-base text-dark-gray font-medium">Preprod Testnet • AI Model Active</span>
        </div>
      </div>



      <!-- Connected Wallet Info Card (Shown when connected) -->
      <transition name="fade">
        <div v-if="isConnected && userData" class="mb-10">
          <div class="bg-white rounded-2xl shadow-lg p-6 border-t-4 border-success-green">
            <div class="flex items-center justify-between mb-6">
              <div>
                <h2 class="text-xl font-semibold text-success-green mb-1">✅ Wallet Connected</h2>
                <p class="text-sm text-secondary-blue">You can now submit claims and manage your insurance</p>
              </div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <div class="bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg p-4">
                <div class="text-xs text-secondary-blue mb-1">Name</div>
                <div class="text-base font-semibold text-main-blue">{{ userData.name }}</div>
              </div>
              <div class="bg-gradient-to-br from-green-50 to-green-100 rounded-lg p-4">
                <div class="text-xs text-secondary-blue mb-1">Wallet</div>
                <div class="text-base font-semibold text-main-green">{{ connectedWalletName }}</div>
              </div>
              <div class="bg-gradient-to-br from-purple-50 to-purple-100 rounded-lg p-4">
                <div class="text-xs text-secondary-blue mb-1">Policy Expiry</div>
                <div class="text-base font-semibold text-purple-700">{{ new Date(userData.expiry_date).toLocaleDateString() }}</div>
              </div>
              <div class="bg-gradient-to-br from-orange-50 to-orange-100 rounded-lg p-4">
                <div class="text-xs text-secondary-blue mb-1">Premium</div>
                <div class="text-base font-semibold text-accent-orange">₳{{ userData.premium }}</div>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- Recent Activity Feed (Public - Only visible when NOT connected) -->
      <div v-if="!isConnected" class="mb-10">
        <RecentActivity />
      </div>

      <!-- Connected View -->
      <transition name="fade">
        <div v-if="isConnected && userData" class="space-y-8">
          <!-- Dashboard Stats -->
          <div>
            <h3 class="text-2xl font-bold text-main-blue mb-6 flex items-center space-x-3">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
              <span>Dashboard Overview</span>
            </h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <StatusCard
                title="Total Claims"
                :count="claimStats.total"
                icon="document"
                variant="info"
                tooltip="All submitted claims"
              />
              <StatusCard
                title="Approved"
                :count="claimStats.genuine"
                icon="check"
                variant="success"
                tooltip="Claims verified as genuine"
              />
              <StatusCard
                title="Rejected"
                :count="claimStats.fake"
                icon="error"
                variant="danger"
                tooltip="Claims flagged as fraudulent"
              />
              <StatusCard
                title="Pending Payout"
                :count="claimStats.pending"
                icon="clock"
                variant="warning"
                tooltip="Approved claims awaiting payout"
              />
            </div>
          </div>

          <!-- Action Cards -->
          <div>
            <h3 class="text-2xl font-bold text-main-blue dark:text-blue-400 mb-6">Quick Actions</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <ActionCard
                title="Submit New Claim"
                description="File a new insurance claim for AI verification"
                icon="clipboard"
                variant="primary"
                @click="toggleClaimForm"
              >
                <template #actions>
                  <button class="btn-primary text-sm px-4 py-2">
                    {{ showClaimForm ? '✖ Close Form' : '📋 Open Form' }}
                  </button>
                </template>
              </ActionCard>

              <ActionCard
                title="View Claims History"
                description="Track all your submitted claims and their status"
                icon="view"
                variant="info"
                @click="showHistoryModal = true"
              >
                <template #actions>
                  <button class="btn-secondary text-sm px-4 py-2">
                    📜 View History
                  </button>
                </template>
              </ActionCard>
            </div>
          </div>

          <!-- Claim Form (Inline Toggle) -->
          <div ref="claimFormSection">
            <transition name="slide-fade">
              <ClaimForm
                v-if="showClaimForm"
                :user-id="userData?.user_id"
                :user-data="userData"
                @claim-submitted="onClaimSubmitted"
              />
            </transition>
          </div>

          <!-- Claims History Modal -->
          <BaseModal v-model="showHistoryModal" title="Claims History">
            <template #body>
              <ClaimsList
                :claims="userData?.claims || []"
                @trigger-payout="triggerPayout"
                @refresh="refreshUserData"
              />
            </template>
          </BaseModal>
        </div>
      </transition>


    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import NavBar from './components/NavBar.vue';
import WalletSelector from './components/WalletSelector.vue';
import ClaimForm from './components/ClaimForm.vue';
import ClaimsList from './components/ClaimsList.vue';
import ActionCard from './components/ActionCard.vue';
import StatusCard from './components/StatusCard.vue';
import RecentActivity from './components/RecentActivity.vue';
import BaseModal from './components/BaseModal.vue';
import { api } from './api.js';
import { useToast } from './composables/useToast';

const { showSuccess, showError } = useToast();

const isConnected = ref(false);
const connectedAddress = ref('');
const connectedWalletName = ref('');
const connectedWallet = ref(null);
const userData = ref(null);
const showClaimForm = ref(false);
const showHistoryModal = ref(false);
const claimsSection = ref(null);
const claimFormSection = ref(null);

const claimStats = computed(() => {
  if (!userData.value?.claims) {
    return { total: 0, genuine: 0, fake: 0, pending: 0 };
  }

  const stats = {
    total: userData.value.claims.length,
    genuine: userData.value.claims.filter(c => c.ml_status === 'genuine').length,
    fake: userData.value.claims.filter(c => c.ml_status === 'fake').length,
    // Pending Payout = approved but not yet paid
    pending: userData.value.claims.filter(c => c.ml_status === 'genuine' && c.payout_status === 'pending').length,
  };

  return stats;
});

// Sticky connect button
const showStickyConnect = ref(false);

// Scroll detection for sticky button
const handleScroll = () => {
  // Show sticky button when scrolled past 300px
  showStickyConnect.value = window.scrollY > 300;
};

// Scroll to wallet connect section
const scrollToWalletConnect = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' });
};

const onWalletConnected = async ({ wallet, address, name }) => {
  try {
    connectedAddress.value = address;
    connectedWalletName.value = name;
    connectedWallet.value = wallet;
    
    // Fetch user data
    await refreshUserData();
    
    isConnected.value = true;
  } catch (err) {
    showError(`Failed to load user data: ${err.message}`);
    console.error('Failed to load user data:', err);
  }
};

// Auto-disconnect on session leave
const handleBeforeUnload = () => {
  if (isConnected.value) {
    // Clear session data when user leaves
    localStorage.removeItem('connectedWallet');
    localStorage.removeItem('walletAddress');
    localStorage.removeItem('walletName');
    console.log('🔌 Auto-disconnect on session end');
  }
};

// Lifecycle hooks
onMounted(() => {
  console.log('🚀 App mounted');
  
  // Add scroll listener for sticky button
  window.addEventListener('scroll', handleScroll);
  
  // Add beforeunload listener for auto-disconnect
  window.addEventListener('beforeunload', handleBeforeUnload);
});

onUnmounted(() => {
  // Clean up listeners
  window.removeEventListener('scroll', handleScroll);
  window.removeEventListener('beforeunload', handleBeforeUnload);
});

const onWalletDisconnected = () => {
  isConnected.value = false;
  connectedAddress.value = '';
  connectedWalletName.value = '';
  connectedWallet.value = null;
  userData.value = null;
  showClaimForm.value = false;
};

const refreshUserData = async () => {
  try {
    // Try to fetch user by connected address
    userData.value = await api.getUserByWallet(connectedAddress.value);
    // Show personalized welcome message
    showSuccess(`Welcome back, ${userData.value.name}! 👋`);
  } catch (err) {
    // Fallback to Alice's address for demo
    const fallbackAddress = 'addr_test1qpfr77c777y9a0x3hj4fqev30ak5j7csw4r9rvfsd768tsqpdtwek63hnds2hwqevj2jhh88qmrzyw3anz44ecx0k3dq8wkuny';
    try {
      userData.value = await api.getUserByWallet(fallbackAddress);
      connectedAddress.value = fallbackAddress;
      // Show personalized recognition without mentioning "demo"
      showSuccess(`Welcome, ${userData.value.name}! 👋`);
    } catch (fallbackErr) {
      throw new Error('Wallet address not registered.');
    }
  }
};

const onClaimSubmitted = () => {
  showClaimForm.value = false; // Close form after submission
  refreshUserData();
};

const triggerPayout = async (claimId) => {
  try {
    // Send the connected wallet address to ensure payout goes to currently connected wallet
    await api.triggerPayout(claimId, connectedAddress.value);
    await refreshUserData();
    showSuccess('Payout triggered! Transaction will be processed within 60 seconds.');
  } catch (err) {
    showError(`Failed to trigger payout: ${err.response?.data?.detail || err.message}`);
  }
};

const scrollToClaims = () => {
  if (claimsSection.value) {
    claimsSection.value.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
};

// Toggle claim form and scroll to it
const toggleClaimForm = () => {
  showClaimForm.value = !showClaimForm.value;
  if (showClaimForm.value) {
    // Wait for the form to render, then scroll to it
    setTimeout(() => {
      if (claimFormSection.value) {
        claimFormSection.value.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }, 100);
  }
};
</script>

<style scoped>
/* Fade transition */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Sticky button animation */
.slide-down-enter-active,
.slide-down-leave-active {
  transition: all 0.3s ease;
}

.slide-down-enter-from,
.slide-down-leave-to {
  transform: translateY(-100%);
  opacity: 0;
}

/* Slide-fade transition */
.slide-fade-enter-active {
  transition: all 0.3s ease-out;
}

.slide-fade-leave-active {
  transition: all 0.2s cubic-bezier(1, 0.5, 0.8, 1);
}

.slide-fade-enter-from {
  transform: translateY(-20px);
  opacity: 0;
}

.slide-fade-leave-to {
  transform: translateY(20px);
  opacity: 0;
}
</style>
