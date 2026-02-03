<template>
  <div class="bg-white rounded-2xl shadow-lg p-6 border-t-4 border-main-blue">
    <div class="flex items-center justify-between mb-6">
      <div class="flex items-center space-x-3">
        <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
          <svg class="w-6 h-6 text-main-blue" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
          </svg>
        </div>
        <div>
          <h3 class="text-xl font-bold text-main-blue">Recent Activity</h3>
          <p class="text-sm text-secondary-blue">Latest transactions on Cardano blockchain</p>
        </div>
      </div>
      
      <button
        @click="fetchRecentActivity"
        :disabled="loading"
        class="p-2 hover:bg-gray-100 rounded-lg transition"
        title="Refresh"
      >
        <svg
          class="w-5 h-5 text-secondary-blue"
          :class="{ 'animate-spin': loading }"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
        </svg>
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex flex-col items-center justify-center py-12">
      <div class="animate-spin rounded-full h-10 w-10 border-4 border-accent-orange border-t-transparent mb-3"></div>
      <p class="text-secondary-blue text-sm">Loading recent activity...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-8">
      <svg class="w-12 h-12 text-red-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      <p class="text-red-600 text-sm">{{ error }}</p>
    </div>

    <!-- Recent Transactions -->
    <div v-else-if="transactions.length > 0" class="space-y-3">
      <div
        v-for="(tx, index) in transactions"
        :key="tx.id || index"
        class="flex items-start space-x-4 p-4 rounded-xl border-2 transition-all hover:border-accent-orange hover:shadow-md cursor-pointer"
        :class="getTxBorderClass(tx.status)"
        @click="viewTransaction(tx)"
      >
        <!-- Icon -->
        <div class="flex-shrink-0">
          <div
            class="w-10 h-10 rounded-full flex items-center justify-center"
            :class="getTxIconBgClass(tx.status)"
          >
            <svg v-if="tx.status === 'approved'" class="w-6 h-6 text-success-green" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
            <svg v-else class="w-6 h-6 text-danger-red" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
          </div>
        </div>

        <!-- Content -->
        <div class="flex-1 min-w-0">
          <div class="flex items-start justify-between mb-2">
            <div>
              <p class="font-semibold text-main-blue">
                {{ tx.status === 'approved' ? 'Claim Approved' : 'Claim Rejected' }}
              </p>
              <p class="text-xs text-dark-gray mt-1">{{ formatTimeAgo(tx.created_at) }}</p>
            </div>
            <span
              class="px-3 py-1 rounded-full text-xs font-medium"
              :class="getStatusBadgeClass(tx.status)"
            >
              {{ tx.status === 'approved' ? '✅ Approved' : '❌ Rejected' }}
            </span>
          </div>

          <div class="grid grid-cols-2 gap-3 text-sm mb-3">
            <div>
              <span class="text-dark-gray">Amount:</span>
              <span class="font-semibold text-secondary-blue ml-1">₳{{ tx.amount.toLocaleString() }}</span>
            </div>
            <div>
              <span class="text-dark-gray">Diagnosis:</span>
              <span class="font-medium text-secondary-blue ml-1 truncate" :title="tx.diagnosis">
                {{ truncateDiagnosis(tx.diagnosis) }}
              </span>
            </div>
          </div>

          <!-- Transaction Hash -->
          <div class="flex items-center space-x-2 bg-gray-50 rounded px-3 py-2">
            <svg class="w-4 h-4 text-main-blue flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
            </svg>
            <code class="text-xs font-mono text-main-blue flex-1 truncate">
              {{ formatHash(tx.tx_hash) }}
            </code>
            <button
              @click.stop="copyHash(tx.tx_hash)"
              class="p-1 hover:bg-gray-200 rounded transition"
              title="Copy transaction hash"
            >
              <svg class="w-4 h-4 text-secondary-blue" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <!-- View All Link -->
      <div class="text-center pt-2">
        <a
          href="https://preprod.cardanoscan.io/"
          target="_blank"
          rel="noopener noreferrer"
          class="inline-flex items-center space-x-2 text-accent-orange hover:underline font-medium text-sm"
        >
          <span>View all transactions on CardanoScan</span>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
          </svg>
        </a>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else class="text-center py-12">
      <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
      </svg>
      <p class="text-secondary-blue font-medium mb-1">No recent activity</p>
      <p class="text-dark-gray text-sm">Transactions will appear here once claims are processed</p>
    </div>

    <!-- Transaction Details Modal -->
    <TransactionDetailsModal
      v-model="showTransactionModal"
      :tx-hash="selectedTx.tx_hash"
      :claim-id="selectedTx.claim_id"
      :amount="selectedTx.amount"
      :metadata="selectedTx.metadata"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import TransactionDetailsModal from './TransactionDetailsModal.vue';
import { useToast } from '../composables/useToast';

const { showSuccess, showError } = useToast();

// State
const loading = ref(false);
const error = ref('');
const transactions = ref([]);

// Transaction modal
const showTransactionModal = ref(false);
const selectedTx = ref({
  tx_hash: '',
  claim_id: null,
  amount: 0,
  metadata: {},
});

// Fetch recent activity from API
const fetchRecentActivity = async () => {
  loading.value = true;
  error.value = '';

  try {
    // TODO: Replace with actual API endpoint
    // const response = await fetch('/api/public/recent-transactions?limit=5');
    // const data = await response.json();
    
    // Mock data for now (will be replaced with real API call)
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    transactions.value = [
      {
        id: 5,
        claim_id: 45,
        status: 'approved',
        amount: 8500,
        diagnosis: 'Heart Disease',
        tx_hash: '9a8b7c6d5e4f3g2h1i0j9k8l7m6n5o4p3q2r1s0t9u8v7w6x5y4z3a2b1c0',
        created_at: new Date(Date.now() - 1000 * 60 * 15).toISOString(), // 15 min ago
      },
      {
        id: 4,
        claim_id: 44,
        status: 'rejected',
        amount: 12000,
        diagnosis: 'Diabetes',
        tx_hash: '1z2y3x4w5v6u7t8s9r0q1p2o3n4m5l6k7j8i9h0g1f2e3d4c5b6a7z8y9x0',
        created_at: new Date(Date.now() - 1000 * 60 * 45).toISOString(), // 45 min ago
      },
      {
        id: 3,
        claim_id: 43,
        status: 'approved',
        amount: 3200,
        diagnosis: 'Hypertension',
        tx_hash: 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0',
        created_at: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(), // 2 hours ago
      },
      {
        id: 2,
        claim_id: 42,
        status: 'rejected',
        amount: 25000,
        diagnosis: 'Cancer Treatment',
        tx_hash: 'z9y8x7w6v5u4t3s2r1q0p9o8n7m6l5k4j3i2h1g0f9e8d7c6b5a4z3y2x1w0',
        created_at: new Date(Date.now() - 1000 * 60 * 60 * 5).toISOString(), // 5 hours ago
      },
      {
        id: 1,
        claim_id: 41,
        status: 'approved',
        amount: 4750,
        diagnosis: 'Asthma',
        tx_hash: 'q1w2e3r4t5y6u7i8o9p0a1s2d3f4g5h6j7k8l9z0x1c2v3b4n5m6q7w8e9r0',
        created_at: new Date(Date.now() - 1000 * 60 * 60 * 12).toISOString(), // 12 hours ago
      },
    ];
  } catch (err) {
    error.value = 'Failed to load recent activity';
    console.error('Error fetching recent activity:', err);
  } finally {
    loading.value = false;
  }
};

// View transaction details
const viewTransaction = (tx) => {
  selectedTx.value = {
    tx_hash: tx.tx_hash,
    claim_id: tx.claim_id,
    amount: tx.amount,
    metadata: {
      status: tx.status,
      diagnosis: tx.diagnosis,
      created_at: tx.created_at,
    },
  };
  showTransactionModal.value = true;
};

// Copy hash to clipboard
const copyHash = async (hash) => {
  try {
    await navigator.clipboard.writeText(hash);
    showSuccess('Transaction hash copied!');
  } catch (err) {
    showError('Failed to copy');
  }
};

// Helpers
const getTxBorderClass = (status) => {
  return status === 'approved' ? 'border-green-200' : 'border-red-200';
};

const getTxIconBgClass = (status) => {
  return status === 'approved' ? 'bg-green-100' : 'bg-red-100';
};

const getStatusBadgeClass = (status) => {
  return status === 'approved'
    ? 'bg-green-100 text-green-800'
    : 'bg-red-100 text-red-800';
};

const formatHash = (hash) => {
  if (!hash || hash.length <= 20) return hash;
  return `${hash.substring(0, 10)}...${hash.substring(hash.length - 10)}`;
};

const truncateDiagnosis = (diagnosis) => {
  if (!diagnosis || diagnosis.length <= 15) return diagnosis;
  return diagnosis.substring(0, 15) + '...';
};

const formatTimeAgo = (dateString) => {
  const date = new Date(dateString);
  const now = new Date();
  const seconds = Math.floor((now - date) / 1000);

  if (seconds < 60) return 'Just now';
  if (seconds < 3600) return `${Math.floor(seconds / 60)}m ago`;
  if (seconds < 86400) return `${Math.floor(seconds / 3600)}h ago`;
  if (seconds < 604800) return `${Math.floor(seconds / 86400)}d ago`;
  
  return date.toLocaleDateString();
};

// Load on mount
onMounted(() => {
  fetchRecentActivity();
});
</script>
