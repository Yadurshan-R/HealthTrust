<template>
  <div class="space-y-6">
    <!-- Transaction Details Modal -->
    <TransactionDetailsModal
      v-model="showTransactionModal"
      :tx-hash="selectedTransaction.tx_hash"
      :claim-id="selectedTransaction.claim_id"
      :amount="selectedTransaction.amount"
      :metadata="selectedTransaction.metadata"
    />
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div class="flex items-center space-x-2.5">
        <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-main-blue to-main-green flex items-center justify-center">
          <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-bold text-gray-900">My Claims</h3>
        <span class="px-2 py-0.5 bg-blue-100 text-main-blue rounded-full text-xs font-bold">
          {{ claims?.length || 0 }}
        </span>
      </div>
      <button
        @click="$emit('refresh')"
        class="flex items-center space-x-1.5 px-3 py-1.5 bg-gray-50 hover:bg-gray-100 rounded-lg text-secondary-blue font-medium transition-colors text-xs sm:text-sm"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
        </svg>
        <span class="hidden sm:inline">Refresh</span>
      </button>
    </div>

    <!-- Empty State -->
    <div v-if="!claims || claims.length === 0" class="bg-gray-50 rounded-2xl p-10 text-center">
      <div class="text-5xl mb-3">📋</div>
      <h4 class="text-base font-semibold text-secondary-blue mb-1">No Claims Yet</h4>
      <p class="text-xs text-dark-gray">Submit your first insurance claim to get started</p>
    </div>

    <!-- Claims Grid -->
    <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-4">
      <div
        v-for="claim in sortedClaims"
        :key="claim.id"
        class="bg-white rounded-xl shadow-sm hover:shadow-md transition-all duration-300 overflow-hidden border border-gray-100"
      >
        <!-- Card Header -->
        <div class="p-4 sm:p-5">
          <div class="flex items-start justify-between mb-2">
            <div>
              <div class="text-[10px] text-dark-gray font-medium uppercase tracking-wider">Claim</div>
              <div class="text-base font-bold text-main-blue">#{{ claim.id }}</div>
            </div>
            <div class="text-right">
              <div class="text-lg sm:text-xl font-bold text-main-green">₳{{ claim.amount_billed.toFixed(2) }}</div>
              <div class="text-[10px] text-dark-gray">{{ formatDate(claim.created_at) }}</div>
            </div>
          </div>

          <!-- Diagnosis -->
          <div class="flex items-center space-x-1.5 text-xs text-secondary-blue mb-3">
            <svg class="w-3.5 h-3.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
            <span class="truncate">{{ claim.diagnosis }} • Age: {{ claim.age }} • {{ claim.gender }}</span>
          </div>

          <!-- Status badges -->
          <div class="flex flex-wrap gap-1.5 mb-3">
            <!-- ML Status -->
            <span class="badge text-[10px] px-2 py-0.5" :class="{
              'badge-success': claim.ml_status === 'genuine',
              'badge-danger': claim.ml_status === 'fake',
              'badge-warning': claim.ml_status === 'pending'
            }">
              {{ claim.ml_status === 'genuine' ? '✅ ML Genuine' : claim.ml_status === 'fake' ? '❌ ML Fraud' : '⏳ ML Pending' }}
            </span>

            <!-- Image Status -->
            <span class="badge text-[10px] px-2 py-0.5" :class="{
              'badge-success': isImageVerified(claim),
              'badge-danger': isImageFailed(claim),
              'badge-warning': !claim.images
            }">
              {{ getImageVerificationLabel(claim) }}
            </span>

            <!-- Payout Status -->
            <span class="badge text-[10px] px-2 py-0.5" :class="{
              'badge-warning': claim.payout_status === 'pending' || claim.payout_status === 'trigger',
              'badge-success': claim.payout_status === 'completed'
            }">
              {{ getPayoutStatusLabel(claim.payout_status) }}
            </span>
          </div>
        </div>

        <!-- Card Footer / Action -->
        <div class="px-4 sm:px-5 pb-4 sm:pb-5">
          <!-- Rejected Claims - ML flagged as fake -->
          <div v-if="claim.ml_status === 'fake'" class="flex items-center justify-center space-x-1.5 py-2.5 text-danger-red bg-red-50 rounded-lg text-xs">
            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
            <span class="font-semibold">Rejected - AI Fraud Detection</span>
          </div>

          <!-- Image Verification Failed -->
          <div v-else-if="isImageFailed(claim)" class="flex items-center justify-center space-x-1.5 py-2.5 text-danger-red bg-red-50 rounded-lg text-xs">
            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
            <span class="font-semibold">Rejected - Document Failed</span>
          </div>

          <!-- Claim Button -->
          <button
            v-else-if="isClaimApproved(claim)"
            @click="$emit('trigger-payout', claim.id)"
            class="w-full btn-success text-xs py-2.5 flex items-center justify-center space-x-1.5"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>Claim Amount</span>
          </button>

          <!-- Processing -->
          <div v-else-if="claim.payout_status === 'trigger'" class="flex items-center justify-center space-x-2 py-2.5 text-main-blue text-xs">
            <div class="animate-spin rounded-full h-4 w-4 border-2 border-main-blue border-t-transparent"></div>
            <span class="font-semibold">Processing payout...</span>
          </div>

          <!-- Completed with TX -->
          <button
            v-else-if="claim.payout_status === 'completed' && claim.tx_hash"
            @click="showTransaction(claim)"
            class="w-full flex items-center justify-center space-x-1.5 py-2.5 px-4 bg-blue-50 hover:bg-blue-100 rounded-lg text-main-blue font-semibold transition-colors text-xs"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
            <span>View Transaction</span>
          </button>

          <!-- Default -->
          <div v-else class="text-center py-2.5 text-dark-gray text-xs">—</div>
        </div>
      </div>
    </div>

    <!-- Fake Claims Warning -->
    <transition name="fade">
      <div
        v-if="hasFakeClaims"
        class="p-6 bg-red-50 border-l-4 border-danger-red rounded-lg"
      >
        <div class="flex items-start space-x-3">
          <svg class="w-6 h-6 text-danger-red flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
          </svg>
          <div>
            <h4 class="font-bold text-danger-red mb-1">Claims Rejected by AI</h4>
            <p class="text-red-700 text-sm">
              Some claims were flagged as potentially fraudulent. Our verification team will contact you soon.
            </p>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import TransactionDetailsModal from './TransactionDetailsModal.vue';

const props = defineProps({
  claims: {
    type: Array,
    default: () => [],
  },
});

defineEmits(['trigger-payout', 'refresh']);

// Transaction modal
const showTransactionModal = ref(false);
const selectedTransaction = ref({
  tx_hash: '',
  claim_id: null,
  amount: 0,
  metadata: {},
});

const showTransaction = (claim) => {
  selectedTransaction.value = {
    tx_hash: claim.tx_hash,
    claim_id: claim.id,
    amount: claim.amount,
    metadata: {
      claim_id: claim.id,
      block_height: claim.block_height,
      slot: claim.slot,  // Added: slot number
      status: 'confirmed',
      age: claim.age,
      gender: claim.gender,
      diagnosis: claim.diagnosis,
      amount_billed: claim.amount_billed,  // Fixed: was claim.amount
      confidence: claim.confidence,  // Added: ML confidence score
      created_at: claim.created_at,
    },
  };
  showTransactionModal.value = true;
};

const sortedClaims = computed(() => {
  return [...props.claims].sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
});

const hasFakeClaims = computed(() => {
  return props.claims.some(claim => claim.ml_status === 'fake');
});

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
};

const getPayoutStatusLabel = (status) => {
  const labels = {
    'pending': '⏳ Pending',
    'trigger': '🚀 Triggering',
    'completed': '✅ Completed',
  };
  return labels[status] || status;
};

// Image verification helpers
const isImageVerified = (claim) => {
  // Check if images field is explicitly set to 'genuine'
  return claim.images === 'genuine';
};

const isImageFailed = (claim) => {
  // Explicit failed status OR images marked as fake
  return claim.image_verification_status === 'failed' || claim.images === 'fake';
};

const getImageVerificationLabel = (claim) => {
  if (isImageFailed(claim)) {
    return '❌ Failed';
  } else if (isImageVerified(claim)) {
    return '✅ Verified';
  } else if (!claim.images) {
    return '⏳ Pending';
  } else {
    return '—';
  }
};

// Helper to determine if claim is fully approved for payout
const isClaimApproved = (claim) => {
  // ALL conditions must be met for a claim to be claimable:
  // 1. ML must say "genuine"
  // 2. Images can be: not uploaded yet (null) OR verified as genuine
  //    - If no images: button shows (user can claim based on ML alone)
  //    - If images uploaded: must be genuine AND combined score >= 80%
  //    - If combined < 80%: backend sets ml_status = 'fake', button disappears
  // 3. Not already paid or processing
  return claim.can_claim &&                            // Backend allows claiming
         claim.ml_status === 'genuine' &&              // ML model says genuine
         (claim.images === 'genuine' || claim.images === null) &&  // No images yet OR images verified
         claim.payout_status === 'pending';            // Not already paid or processing
};
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
</style>
