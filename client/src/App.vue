<template>
  <div class="min-h-screen bg-light-gray bg-mesh">
    <!-- Navigation Bar -->
    <NavBar
      @wallet-connected="onWalletConnected"
      @disconnect="onWalletDisconnected"
    />

    <!-- Main Container -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8">

      <!-- Hero Section (Before Connect) -->
      <div v-if="!isConnected" class="mb-8 sm:mb-12">
        <div class="relative overflow-hidden rounded-3xl bg-gradient-to-br from-main-blue via-main-blue/95 to-main-green p-8 sm:p-12 lg:p-16 text-white">
          <!-- Decorative elements -->
          <div class="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2"></div>
          <div class="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full translate-y-1/2 -translate-x-1/2"></div>
          <div class="absolute top-1/2 right-1/4 w-32 h-32 bg-accent-orange/10 rounded-full animate-float"></div>

          <div class="relative z-10 max-w-2xl">
            <div class="flex items-center space-x-2 mb-4">
              <div class="w-2 h-2 rounded-full bg-success-green animate-pulse"></div>
              <span class="text-sm font-medium text-white/80">AI Model Active • Cardano Preprod</span>
            </div>
            <h1 class="text-3xl sm:text-4xl lg:text-5xl font-extrabold leading-tight mb-4">
              Decentralized<br />
              <span class="bg-clip-text text-transparent bg-gradient-to-r from-white to-emerald-300">Health Insurance</span>
            </h1>
            <p class="text-base sm:text-lg text-white/70 mb-8 max-w-lg leading-relaxed">
              AI-powered fraud detection with immutable Cardano blockchain verification. Connect your wallet to submit and manage insurance claims.
            </p>
            <div class="flex flex-wrap items-center gap-3">
              <div class="flex items-center space-x-2 px-4 py-2 bg-white/10 backdrop-blur rounded-full text-sm">
                <span>🤖</span><span>ML Fraud Detection</span>
              </div>
              <div class="flex items-center space-x-2 px-4 py-2 bg-white/10 backdrop-blur rounded-full text-sm">
                <span>⛓️</span><span>Blockchain Verified</span>
              </div>
              <div class="flex items-center space-x-2 px-4 py-2 bg-white/10 backdrop-blur rounded-full text-sm">
                <span>📸</span><span>Image Verification</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Connected Wallet Info Card -->
      <transition name="fade">
        <div v-if="isConnected && userData" class="mb-8 sm:mb-10">
          <div class="relative overflow-hidden bg-white rounded-2xl shadow-lg border border-gray-100">
            <!-- Top gradient accent -->
            <div class="h-1.5 bg-gradient-to-r from-success-green via-main-green to-main-blue"></div>
            <div class="p-5 sm:p-6">
              <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-5 gap-3">
                <div class="flex items-center space-x-3">
                  <div class="w-10 h-10 rounded-full bg-gradient-to-br from-success-green to-main-green flex items-center justify-center shadow-md">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7" />
                    </svg>
                  </div>
                  <div>
                    <h2 class="text-lg font-bold text-gray-900">Welcome, {{ userData.name }}!</h2>
                    <p class="text-sm text-secondary-blue">Wallet connected & ready</p>
                  </div>
                </div>
              </div>
              <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
                <div class="bg-gradient-to-br from-blue-50 to-blue-100/50 rounded-xl p-3 sm:p-4 border border-blue-100">
                  <div class="text-[10px] sm:text-xs font-medium text-secondary-blue mb-1 uppercase tracking-wider">Patient</div>
                  <div class="text-sm sm:text-base font-bold text-main-blue truncate">{{ userData.name }}</div>
                </div>
                <div class="bg-gradient-to-br from-green-50 to-green-100/50 rounded-xl p-3 sm:p-4 border border-green-100">
                  <div class="text-[10px] sm:text-xs font-medium text-secondary-blue mb-1 uppercase tracking-wider">Wallet</div>
                  <div class="text-sm sm:text-base font-bold text-main-green truncate">{{ connectedWalletName }}</div>
                </div>
                <div class="bg-gradient-to-br from-purple-50 to-purple-100/50 rounded-xl p-3 sm:p-4 border border-purple-100">
                  <div class="text-[10px] sm:text-xs font-medium text-secondary-blue mb-1 uppercase tracking-wider">Expiry</div>
                  <div class="text-sm sm:text-base font-bold text-purple-700">{{ new Date(userData.expiry_date).toLocaleDateString() }}</div>
                </div>
                <div class="bg-gradient-to-br from-orange-50 to-orange-100/50 rounded-xl p-3 sm:p-4 border border-orange-100">
                  <div class="text-[10px] sm:text-xs font-medium text-secondary-blue mb-1 uppercase tracking-wider">Premium</div>
                  <div class="text-sm sm:text-base font-bold text-accent-orange">₳{{ userData.premium }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- Recent Activity Feed (Public - Only visible when NOT connected) -->
      <div v-if="!isConnected" class="mb-8 sm:mb-10">
        <RecentActivity />
      </div>

      <!-- Connected View -->
      <transition name="fade">
        <div v-if="isConnected && userData" class="space-y-6 sm:space-y-8">
          <!-- Dashboard Stats -->
          <div>
            <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mb-4 sm:mb-6 flex items-center space-x-3">
              <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-main-blue to-main-green flex items-center justify-center">
                <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <span>Dashboard Overview</span>
            </h3>
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
              <StatusCard
                title="Total Claims"
                :count="claimStats.total"
                icon="document"
                variant="info"
                tooltip="All submitted claims"
                :clickable="true"
                @click="openFilteredClaims('total', 'Total Claims')"
              />
              <StatusCard
                title="Approved"
                :count="claimStats.genuine"
                icon="check"
                variant="success"
                tooltip="Claims verified as genuine"
                :clickable="true"
                @click="openFilteredClaims('approved', 'Approved Claims')"
              />
              <StatusCard
                title="Rejected"
                :count="claimStats.fake"
                icon="error"
                variant="danger"
                tooltip="Claims flagged as fraudulent"
                :clickable="true"
                @click="openFilteredClaims('rejected', 'Rejected Claims')"
              />
              <StatusCard
                title="Pending Payout"
                :count="claimStats.pending"
                icon="clock"
                variant="warning"
                tooltip="Approved claims awaiting payout"
                :clickable="true"
                @click="openFilteredClaims('pending', 'Pending Payout Claims')"
              />
            </div>
          </div>

          <!-- Action Cards -->
          <div>
            <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mb-4 sm:mb-6">Quick Actions</h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-6">
              <ActionCard
                title="Submit New Claim"
                description="File a new insurance claim for AI verification"
                icon="clipboard"
                variant="primary"
                @click="toggleClaimForm"
              >
                <template #actions>
                  <button class="btn-primary text-sm px-5 py-2.5">
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
                  <button class="btn-secondary text-sm px-5 py-2.5">
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

          <!-- Filtered Claims Modal (from dashboard stat cards) -->
          <BaseModal v-model="showFilteredModal" :title="filteredModalTitle">
            <template #body>
              <ClaimsList
                :claims="userData?.claims || []"
                :filter-type="activeFilter"
                @trigger-payout="triggerPayout"
                @refresh="refreshUserData"
              />
            </template>
          </BaseModal>

          <!-- Profile Setup Modal (for new users) -->
          <BaseModal v-model="showProfileSetup" title="Set Up Your Profile">
            <template #body>
              <div class="space-y-5">
                <p class="text-sm text-gray-600">Welcome to HealthTrust! Please fill in your details to get started.</p>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-1.5">Full Name</label>
                  <input v-model="profileForm.name" type="text" placeholder="e.g. John Doe"
                    class="input-base w-full" />
                </div>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-1.5">Age</label>
                  <input v-model="profileForm.age" type="number" min="1" max="120" placeholder="e.g. 30"
                    class="input-base w-full" />
                </div>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-1.5">Gender</label>
                  <div class="flex gap-3">
                    <button @click="profileForm.gender = 'Male'"
                      :class="profileForm.gender === 'Male' ? 'bg-main-blue text-white ring-2 ring-main-blue/30' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'"
                      class="flex-1 py-2.5 rounded-xl font-semibold text-sm transition-all duration-200">
                      Male
                    </button>
                    <button @click="profileForm.gender = 'Female'"
                      :class="profileForm.gender === 'Female' ? 'bg-main-green text-white ring-2 ring-main-green/30' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'"
                      class="flex-1 py-2.5 rounded-xl font-semibold text-sm transition-all duration-200">
                      Female
                    </button>
                  </div>
                </div>

                <button @click="saveProfile"
                  :disabled="!profileForm.name || !profileForm.age || !profileForm.gender"
                  class="w-full btn-primary py-3 text-base font-bold disabled:opacity-40 disabled:cursor-not-allowed">
                  Save & Continue
                </button>
              </div>
            </template>
          </BaseModal>
        </div>
      </transition>

      <!-- Footer -->
      <footer class="mt-12 sm:mt-16 pb-8 text-center">
        <div class="border-t border-gray-200 pt-6">
          <p class="text-xs sm:text-sm text-dark-gray">Built with ❤️ on Cardano • HealthTrust © {{ new Date().getFullYear() }}</p>
        </div>
      </footer>

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

const { showSuccess, showError, showInfo } = useToast();

const isConnected = ref(false);
const connectedAddress = ref('');
const connectedWalletName = ref('');
const connectedWallet = ref(null);
const userData = ref(null);
const showClaimForm = ref(false);
const showHistoryModal = ref(false);
const showFilteredModal = ref(false);
const showProfileSetup = ref(false);
const profileForm = ref({ name: '', age: '', gender: '' });
const activeFilter = ref(null);
const filteredModalTitle = ref('Claims');
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
    userData.value = await api.getUserByWallet(connectedAddress.value);

    // Check if this is a new auto-registered user (name starts with "User_")
    if (userData.value.name.startsWith('User_')) {
      // Small delay to ensure the connected view renders first
      setTimeout(() => {
        showProfileSetup.value = true;
        showInfo('Welcome! Please set up your profile to get started.');
      }, 500);
    } else {
      showSuccess(`Welcome back, ${userData.value.name}! 👋`);
    }
  } catch (err) {
    throw new Error('Failed to connect wallet. Please try again.');
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

const saveProfile = async () => {
  try {
    if (!profileForm.value.name || !profileForm.value.age || !profileForm.value.gender) {
      showError('Please fill in all fields');
      return;
    }
    await api.updateProfile(connectedAddress.value, {
      name: profileForm.value.name,
      age: parseInt(profileForm.value.age),
      gender: profileForm.value.gender
    });
    showProfileSetup.value = false;
    // Refresh to get updated data
    userData.value = await api.getUserByWallet(connectedAddress.value);
    showSuccess(`Welcome, ${userData.value.name}! Your profile is set up. 🎉`);
  } catch (err) {
    showError(`Failed to save profile: ${err.response?.data?.detail || err.message}`);
  }
};

const scrollToClaims = () => {
  if (claimsSection.value) {
    claimsSection.value.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
};

// Open filtered claims modal when clicking a dashboard stat card
const openFilteredClaims = (filterType, title) => {
  activeFilter.value = filterType;
  filteredModalTitle.value = title;
  showFilteredModal.value = true;
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
