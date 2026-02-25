<template>
  <BaseModal v-model="isOpen" title="Transaction Details">
    <template #body>
      <div class="p-6">
        <!-- Loading State -->
        <div v-if="loading" class="flex flex-col items-center justify-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-4 border-main-green border-t-transparent mb-4"></div>
          <p class="text-secondary-blue font-medium">Loading transaction details...</p>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="text-center py-8">
          <svg class="w-16 h-16 text-red-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p class="text-red-600 font-semibold mb-2">Failed to load transaction details</p>
          <p class="text-gray-500 text-sm mb-4">{{ error }}</p>
          <button
            @click="$emit('retry')"
            class="px-4 py-2 bg-main-blue text-white rounded-lg hover:bg-opacity-90 transition"
          >
            Try Again
          </button>
        </div>

        <!-- Transaction Details -->
        <div v-else class="space-y-6">
          <!-- Header: Transaction Hash -->
          <div class="bg-gradient-to-r from-main-blue to-main-green p-6 rounded-xl text-white">
            <div class="flex items-center justify-between mb-3">
              <h3 class="text-lg font-semibold">Blockchain Transaction</h3>
              <div class="flex items-center space-x-2">
                <button
                  @click="refreshBlockchainData"
                  :disabled="fetchingBlockchain"
                  class="flex items-center space-x-1 px-2.5 py-1 bg-white/20 hover:bg-white/30 rounded-full text-xs font-medium transition disabled:opacity-50"
                  title="Refresh transaction data"
                >
                  <svg class="w-3.5 h-3.5" :class="{ 'animate-spin': fetchingBlockchain }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                  </svg>
                  <span>{{ fetchingBlockchain ? 'Refreshing...' : 'Refresh' }}</span>
                </button>
                <span class="px-3 py-1 bg-white/20 rounded-full text-xs font-medium">
                  ✓ Verified
                </span>
              </div>
            </div>
            
            <div class="space-y-2">
              <label class="text-xs opacity-80">Transaction Hash</label>
              <div class="flex items-center space-x-2">
                <code class="flex-1 bg-white/10 rounded px-3 py-2 text-sm font-mono break-all">
                  {{ txHash }}
                </code>
                <button
                  @click="copyToClipboard(txHash)"
                  class="flex-shrink-0 p-2 hover:bg-white/10 rounded transition"
                  title="Copy transaction hash"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <!-- Block Information -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-700 rounded-lg p-4">
              <label class="text-xs font-semibold text-blue-900 dark:text-blue-300 uppercase">Block Height</label>
              <p class="text-2xl font-bold text-blue-700 dark:text-blue-400 mt-1">
                <span v-if="fetchingBlockchain" class="flex items-center space-x-2">
                  <div class="animate-spin rounded-full h-5 w-5 border-2 border-blue-700 border-t-transparent"></div>
                  <span class="text-sm">Loading...</span>
                </span>
                <span v-else>{{ blockchainData?.block_height?.toLocaleString() || metadata?.block_height?.toLocaleString() || 'N/A' }}</span>
              </p>
            </div>
            
            <div class="bg-purple-50 dark:bg-purple-900/20 border border-purple-200 dark:border-purple-700 rounded-lg p-4">
              <label class="text-xs font-semibold text-purple-900 dark:text-purple-300 uppercase">Epoch / Slot</label>
              <div class="mt-1">
                <p class="text-2xl font-bold text-purple-700 dark:text-purple-400">
                  {{ (metadata?.slot || blockchainData?.slot) ? `${calculateEpoch(metadata?.slot || blockchainData?.slot)} / ${(metadata?.slot || blockchainData?.slot).toLocaleString()}` : '—' }}
                </p>
              </div>
            </div>
          </div>

          <!-- Claim Metadata -->
          <div class="border border-gray-200 rounded-xl p-5">
            <h4 class="text-lg font-semibold text-main-blue mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              Claim Metadata on Blockchain
            </h4>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
              <!-- Claim ID -->
              <div class="space-y-2">
                <label class="text-xs font-semibold uppercase text-gray-600">Claim ID</label>
                <div class="flex items-center space-x-2">
                  <div class="flex-1 bg-purple-50 border border-purple-200 rounded p-3">
                    <code class="text-purple-700 font-mono text-sm">
                      #{{ metadata?.claim_id || claimId }}
                    </code>
                  </div>
                  <button
                    @click="copyToClipboard(String(metadata?.claim_id || claimId))"
                    class="p-2 hover:bg-gray-100 rounded transition"
                    title="Copy"
                  >
                    📋
                  </button>
                </div>
              </div>

              <!-- Amount Billed -->
              <div class="space-y-2">
                <label class="text-xs font-semibold uppercase text-gray-600">Amount Billed (USD)</label>
                <div class="bg-green-50 border border-green-200 rounded p-3">
                  <p class="text-green-700 font-semibold text-lg">
                    ${{ metadata?.amount_billed?.toLocaleString() || amount }}
                  </p>
                  <p v-if="metadata?.amount_ada" class="text-main-blue text-sm font-semibold mt-0.5">
                    ≈ ₳{{ metadata.amount_ada.toFixed(2) }} ADA
                  </p>
                </div>
              </div>

              <!-- Patient Info -->
              <div class="space-y-2">
                <label class="text-xs font-semibold uppercase text-gray-600">Patient Age</label>
                <div class="bg-blue-50 border border-blue-200 rounded p-3">
                  <p class="text-blue-700 font-medium">
                    {{ metadata?.age || 'N/A' }} years
                  </p>
                </div>
              </div>

              <div class="space-y-2">
                <label class="text-xs font-semibold uppercase text-gray-600">Gender</label>
                <div class="bg-blue-50 border border-blue-200 rounded p-3">
                  <p class="text-blue-700 font-medium capitalize">
                    {{ metadata?.gender || 'N/A' }}
                  </p>
                </div>
              </div>

              <!-- Diagnosis -->
              <div class="space-y-2 lg:col-span-2">
                <label class="text-xs font-semibold uppercase text-gray-600">Diagnosis</label>
                <div class="bg-orange-50 border border-orange-200 rounded p-3">
                  <p class="text-orange-700 font-medium">
                    {{ metadata?.diagnosis || 'N/A' }}
                  </p>
                </div>
              </div>

              <!-- Timestamp -->
              <div class="space-y-2 lg:col-span-2">
                <label class="text-xs font-semibold uppercase text-gray-600">Submitted On</label>
                <div class="bg-gray-50 border border-gray-200 rounded p-3">
                  <p class="text-gray-700 font-medium">
                    {{ formatDateTime(metadata?.created_at || new Date().toISOString()) }}
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Verification Notice -->
          <div class="bg-green-50 border border-green-200 rounded-lg p-4">
            <div class="flex items-start">
              <svg class="w-6 h-6 text-green-600 mr-3 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              <div class="flex-1">
                <p class="font-semibold text-green-800 mb-1">
                  ✅ Verified on Cardano Blockchain
                </p>
                <p class="text-green-700 text-sm">
                  This claim metadata is immutably recorded on the Cardano blockchain and cannot be altered. 
                  All information is cryptographically secured and permanently verifiable.
                </p>
              </div>
            </div>
          </div>

          <!-- Explorer Link -->
          <div class="pt-2">
            <a
              :href="explorerUrl"
              target="_blank"
              rel="noopener noreferrer"
              class="flex items-center justify-center space-x-2 w-full py-3 px-4 bg-main-blue text-white rounded-lg hover:bg-opacity-90 transition font-medium"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
              </svg>
              <span>View Full Details on CardanoScan</span>
            </a>
          </div>
        </div>
      </div>
    </template>
  </BaseModal>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import BaseModal from './BaseModal.vue';
import { useToast } from '../composables/useToast';

const props = defineProps({
  modelValue: {
    type: Boolean,
    required: true,
  },
  txHash: {
    type: String,
    required: true,
  },
  claimId: {
    type: [Number, String],
    default: null,
  },
  amount: {
    type: [Number, String],
    default: 0,
  },
  metadata: {
    type: Object,
    default: () => ({}),
  },
  loading: {
    type: Boolean,
    default: false,
  },
  error: {
    type: String,
    default: '',
  },
});

const emit = defineEmits(['update:modelValue', 'retry']);

const { showSuccess, showError } = useToast();

const isOpen = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
});

// Blockchain data from API
const fetchingBlockchain = ref(false);
const blockchainData = ref(null);

// Fetch blockchain data from Blockfrost when modal opens
watch(() => props.modelValue, async (isOpen) => {
  if (isOpen && props.txHash && !blockchainData.value) {
    await fetchBlockchainData();
  }
});

const fetchBlockchainData = async () => {
  if (!props.txHash) return;
  
  fetchingBlockchain.value = true;
  try {
    // Fetch from our own blockchain service via Nginx reverse proxy
    const response = await fetch(`/service/api/transaction/${props.txHash}`);
    
    if (response.ok) {
      const data = await response.json();
      blockchainData.value = {
        block_height: data.blockHeight,
        block_time: data.blockTimestamp,
        confirmations: data.confirmations || 0,
        slot: data.slot,
        fees: data.fees,
      };
    } else {
      console.error('Failed to fetch blockchain data:', response.status);
    }
  } catch (error) {
    console.error('Error fetching blockchain data:', error);
  } finally {
    fetchingBlockchain.value = false;
  }
};

const refreshBlockchainData = async () => {
  blockchainData.value = null;
  await fetchBlockchainData();
  if (blockchainData.value) {
    showSuccess('Transaction data refreshed ✓');
  }
};

const explorerUrl = computed(() => {
  // Preprod testnet explorer
  return `https://preprod.cardanoscan.io/transaction/${props.txHash}`;
});

const getStatusClass = (status) => {
  switch (status?.toLowerCase()) {
    case 'confirmed':
      return 'bg-green-100 text-green-800';
    case 'pending':
      return 'bg-yellow-100 text-yellow-800';
    case 'failed':
      return 'bg-red-100 text-red-800';
    default:
      return 'bg-gray-100 text-gray-800';
  }
};

const formatStatus = (status) => {
  if (!status) return 'Confirmed';
  return status.charAt(0).toUpperCase() + status.slice(1);
};

const formatDateTime = (isoString) => {
  try {
    const date = new Date(isoString);
    return date.toLocaleString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      hour12: true,
    });
  } catch {
    return isoString;
  }
};

const copyToClipboard = async (text) => {
  try {
    await navigator.clipboard.writeText(text);
    showSuccess('Copied to clipboard!');
  } catch (err) {
    console.error('Failed to copy:', err);
    showError('Failed to copy to clipboard');
  }
};

const getConfidenceClass = (confidence) => {
  if (!confidence) return 'bg-gray-100 border border-gray-300 text-gray-700';
  if (confidence >= 0.95) return 'bg-green-100 border border-green-300 text-green-800';
  if (confidence >= 0.80) return 'bg-yellow-100 border border-yellow-300 text-yellow-800';
  return 'bg-red-100 border border-red-300 text-red-800';
};

const getConfidenceLabel = (confidence) => {
  if (!confidence) return '';
  if (confidence >= 0.95) return 'High Confidence ✓';
  if (confidence >= 0.80) return 'Medium Confidence';
  return 'Low Confidence';
};

// Calculate epoch from slot number
// Cardano: 1 epoch = 432,000 slots (5 days)
const calculateEpoch = (slot) => {
  if (!slot) return null;
  const SLOTS_PER_EPOCH = 432000;
  return Math.floor(slot / SLOTS_PER_EPOCH);
};
</script>
