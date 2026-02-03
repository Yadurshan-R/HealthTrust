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
      <div class="flex items-center space-x-3">
        <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
          <svg class="w-6 h-6 text-main-blue" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <h3 class="text-2xl font-bold text-main-blue">My Claims</h3>
        <span class="px-3 py-1 bg-blue-100 text-main-blue rounded-full text-sm font-semibold">
          {{ claims?.length || 0 }}
        </span>
      </div>
      <button
        @click="$emit('refresh')"
        class="flex items-center space-x-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg text-secondary-blue font-medium transition-colors"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
        </svg>
        <span>Refresh</span>
      </button>
    </div>

    <!-- Empty State -->
    <div v-if="!claims || claims.length === 0" class="bg-white rounded-2xl shadow-card p-12 text-center">
      <div class="text-7xl mb-4">📋</div>
      <h4 class="text-xl font-semibold text-secondary-blue mb-2">No Claims Yet</h4>
      <p class="text-dark-gray">Submit your first insurance claim to get started</p>
    </div>

    <!-- Claims Grid -->
    <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div
        v-for="claim in sortedClaims"
        :key="claim.id"
        class="bg-white rounded-2xl shadow-card hover:shadow-card-hover transition-all duration-300 overflow-hidden border-l-4"
        :class="{
          'border-success-green': claim.ml_status === 'genuine',
          'border-danger-red': claim.ml_status === 'fake',
          'border-warning-yellow': claim.ml_status === 'pending'
        }"
      >
        <!-- Card Header -->
        <div class="p-6 border-b border-gray-100">
          <div class="flex items-start justify-between mb-3">
            <div>
              <div class="text-xs text-dark-gray font-medium mb-1">Claim ID</div>
              <div class="text-lg font-bold text-main-blue">#{{ claim.id }}</div>
            </div>
            <div class="text-right">
              <div class="text-2xl font-bold text-main-green">₳{{ claim.amount_billed.toFixed(2) }}</div>
              <div class="text-xs text-dark-gray">{{ formatDate(claim.created_at) }}</div>
            </div>
          </div>

          <!-- Diagnosis -->
          <div class="flex items-center space-x-2 text-sm text-secondary-blue">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
            <span>{{ claim.diagnosis }} | Age: {{ claim.age }} | {{ claim.gender }}</span>
          </div>
        </div>

        <!-- Card Body -->
        <div class="p-6 bg-gray-50">
          <div class="grid grid-cols-2 gap-4 mb-4">
            <!-- ML Status -->
            <div>
              <div class="text-xs text-dark-gray font-medium mb-2">ML Verification</div>
              <span class="badge" :class="{
                'badge-success': claim.ml_status === 'genuine',
                'badge-danger': claim.ml_status === 'fake',
                'badge-warning': claim.ml_status === 'pending'
              }">
                {{ claim.ml_status === 'genuine' ? '✅ Genuine' : claim.ml_status === 'fake' ? '❌ Fraud' : '⏳ Pending' }}
              </span>
            </div>

            <!-- Payout Status -->
            <div>
              <div class="text-xs text-dark-gray font-medium mb-2">Payout Status</div>
              <span class="badge" :class="{
                'badge-warning': claim.payout_status === 'pending' || claim.payout_status === 'trigger',
                  'badge-success': claim.payout_status === 'completed'
              }">
                {{ getPayoutStatusLabel(claim.payout_status) }}
              </span>
            </div>
          </div>

          <!-- Action -->
          <div class="pt-4 border-t border-gray-200">
            <!-- Rejected Claims - Show first to prevent any button from showing -->
            <div v-if="claim.ml_status === 'fake'" class="flex items-center justify-center space-x-2 py-3 text-danger-red">
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
              </svg>
              <span class="font-semibold">Claim Rejected</span>
            </div>

            <!-- Claim Button - Only for genuine claims -->
            <button
              v-else-if="claim.can_claim && claim.ml_status === 'genuine'"
              @click="$emit('trigger-payout', claim.id)"
              class="w-full btn-success flex items-center justify-center space-x-2"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span>Claim Amount</span>
            </button>

            <!-- Processing -->
            <div v-else-if="claim.payout_status === 'trigger'" class="flex items-center justify-center space-x-2 py-3 text-main-blue">
              <div class="animate-spin rounded-full h-5 w-5 border-2 border-main-blue border-t-transparent"></div>
              <span class="font-semibold">Processing payout...</span>
            </div>

            <!-- Completed with TX - View Details Button -->
            <button
              v-else-if="claim.payout_status === 'completed' && claim.tx_hash"
              @click="showTransaction(claim)"
              class="w-full flex items-center justify-center space-x-2 py-3 px-4 bg-blue-100 hover:bg-blue-200 rounded-lg text-main-blue font-semibold transition-colors"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              <span>View Transaction Details</span>
            </button>

            <!-- Default -->
            <div v-else class="text-center py-3 text-dark-gray">—</div>
          </div>
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
