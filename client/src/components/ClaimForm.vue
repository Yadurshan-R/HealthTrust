<template>
  <div class="bg-gradient-to-br from-white to-blue-50 rounded-3xl shadow-2xl p-10 border-t-8 border-accent-orange">
    <!-- Header with BIG Icon -->
    <div class="flex items-center space-x-4 mb-8">
      <div class="w-20 h-20 rounded-2xl bg-gradient-to-br from-accent-orange to-orange-600 flex items-center justify-center shadow-lg">
        <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      </div>
      <div>
        <h3 class="text-3xl font-bold text-main-blue">Submit Insurance Claim</h3>
        <p class="text-secondary-blue">AI-powered fraud detection & instant verification</p>
      </div>
    </div>

    <form @submit.prevent="submitClaim" class="space-y-8">
      <!--Patient Information (Auto-loaded from Database) -->
      <div class="bg-white dark:bg-slate-800 rounded-2xl p-6 border-l-4 border-main-blue shadow-md">
        <div class="flex items-center space-x-3 mb-4">
          <svg class="w-8 h-8 text-main-blue dark:text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
          <h4 class="text-xl font-bold text-main-blue dark:text-blue-400">Patient Information</h4>
          <span class="ml-auto px-3 py-1 bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-300 text-xs font-semibold rounded-full">From your account</span>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4 border border-blue-200 dark:border-blue-700">
            <div class="text-xs text-secondary-blue dark:text-gray-400 mb-1">Patient Name</div>
            <div class="text-lg font-semibold text-main-blue dark:text-blue-300">{{ userData?.name || 'Connected User' }}</div>
          </div>
          <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4 border border-blue-200 dark:border-blue-700">
            <div class="text-xs text-secondary-blue dark:text-gray-400 mb-1">Age</div>
            <div class="text-lg font-semibold text-main-blue dark:text-blue-300">{{ userData?.age || 'Not set' }} years</div>
          </div>
          <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4 border border-blue-200 dark:border-blue-700">
            <div class="text-xs text-secondary-blue dark:text-gray-400 mb-1">Gender</div>
            <div class="text-lg font-semibold text-main-blue dark:text-blue-300">{{ userData?.gender || 'Not set' }}</div>
          </div>
        </div>
      </div>

      <!-- Hospital Admission Details -->
      <div class="bg-white rounded-2xl p-6 border-l-4 border-accent-orange shadow-md">
        <div class="flex items-center space-x-3 mb-4">
          <svg class="w-8 h-8 text-accent-orange" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
          </svg>
          <h4 class="text-xl font-bold text-accent-orange">Hospital Stay Details</h4>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="block text-sm font-bold text-secondary-blue mb-2 flex items-center space-x-2">
              <svg class="w-5 h-5 text-dark-gray" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <span>Admission Date</span>
            </label>
            <input
              v-model="formData.admission_date"
              type="date"
              required
              class="input-base text-lg"
              :max="formData.discharge_date || today"
            />
          </div>
          <div>
            <label class="block text-sm font-bold text-secondary-blue mb-2 flex items-center space-x-2">
              <svg class="w-5 h-5 text-dark-gray" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <span>Discharge Date</span>
            </label>
            <input
              v-model="formData.discharge_date"
              type="date"
              required
              class="input-base text-lg"
              :min="formData.admission_date"
              :max="today"
            />
          </div>
        </div>
        
        <!-- Days Hospitalized (Auto-calculated) -->
        <div v-if="daysHospitalized > 0" class="mt-4 p-4 bg-blue-50 rounded-lg border border-blue-200">
          <div class="flex items-center space-x-3">
            <svg class="w-6 h-6 text-main-blue" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd" />
            </svg>
            <div>
              <div class="text-sm text-secondary-blue">Duration of Hospital Stay</div>
              <div class="text-2xl font-bold text-main-blue">{{ daysHospitalized }} {{ daysHospitalized === 1 ? 'Day' : 'Days' }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Medical Details -->
      <div class="bg-white rounded-2xl p-6 border-l-4 border-main-green shadow-md">
        <div class="flex items-center space-x-3 mb-4">
          <svg class="w-8 h-8 text-main-green" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <h4 class="text-xl font-bold text-main-green">Treatment & Diagnosis</h4>
        </div>
        <div class="grid grid-cols-1 gap-6">
          <div>
            <label class="block text-sm font-bold text-secondary-blue mb-2 flex items-center space-x-2">
              <svg class="w-5 h-5 text-dark-gray" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <span>Primary Diagnosis *</span>
            </label>
            <select
              v-model="formData.diagnosis"
              required
              class="input-base text-lg"
            >
              <option value="" disabled>Select primary diagnosis...</option>
              <option value="Pregnancy">Pregnancy & Childbirth</option>
              <option value="Hypertension">Hypertension (High Blood Pressure)</option>
              <option value="Diabetes">Diabetes Mellitus</option>
              <option value="Pneumonia">Pneumonia</option>
              <option value="Gastroenteritis">Gastroenteritis</option>
              <option value="Cesarean Section">Cesarean Section</option>
              <option value="Cataract Surgery">Cataract Surgery</option>
              <option value="Other">Other Medical Condition</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Billing Information -->
      <div class="bg-white rounded-2xl p-6 border-l-4 border-success-green shadow-md">
        <div class="flex items-center space-x-3 mb-4">
          <svg class="w-8 h-8 text-success-green" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <h4 class="text-xl font-bold text-success-green">Claim Amount</h4>
        </div>
        <div>
          <label class="block text-sm font-bold text-secondary-blue mb-2">
            Total Amount Billed (₳) *
          </label>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-6 flex items-center pointer-events-none">
              <span class="text-dark-gray text-2xl font-bold">₳</span>
            </div>
            <input
              v-model.number="formData.amount_billed"
              type="number"
              step="0.01"
              min="0"
              required
              class="input-base pl-16 text-2xl font-bold text-main-green"
              placeholder="e.g., 5000.00"
            />
          </div>
          <p class="text-xs text-dark-gray mt-2">Enter the total hospital bill amount including all treatments, room charges, and medications</p>
        </div>
      </div>

      <!-- Document Upload Section -->
      <div class="bg-white rounded-2xl p-6 border-l-4 border-purple-500 shadow-md">
        <div class="flex items-center space-x-3 mb-4">
          <svg class="w-8 h-8 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
          </svg>
          <h4 class="text-xl font-bold text-purple-500">Supporting Documents</h4>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Receipt Upload -->
          <div>
            <label class="block text-sm font-bold text-secondary-blue mb-2">Hospital Receipt *</label>
            
            <!-- Upload area (show when no file) -->
            <div v-if="!receiptFile" class="relative">
              <input type="file" accept="image/*,application/pdf" @change="handleReceiptUpload" class="hidden" id="receipt-upload" />
              <label for="receipt-upload" class="flex items-center justify-center w-full px-4 py-8 border-2 border-dashed border-purple-300 rounded-xl hover:border-purple-500 hover:bg-purple-50 transition-all cursor-pointer group">
                <div class="text-center">
                  <svg class="w-12 h-12 mx-auto text-purple-400 group-hover:text-purple-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                  </svg>
                  <p class="text-sm font-semibold text-purple-600">Click to upload receipt</p>
                  <p class="text-xs text-dark-gray mt-1">PDF, JPG, PNG (Max 10MB)</p>
                </div>
              </label>
            </div>
            
            <!-- File preview (show when file uploaded) -->
            <div v-else class="bg-green-50 border-2 border-green-300 rounded-xl p-4">
              <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3 flex-1">
                  <svg class="w-6 h-6 text-green-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-semibold text-green-800 truncate">{{ receiptFileName }}</p>
                    <p class="text-xs text-green-600">{{ formatFileSize(receiptFile.size) }}</p>
                  </div>
                </div>
                <button 
                  @click="removeReceipt" 
                  type="button"
                  class="ml-3 p-2 hover:bg-red-100 rounded-lg transition-colors group"
                  title="Remove file"
                >
                  <svg class="w-5 h-5 text-red-600 group-hover:text-red-700" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <!-- Prescription Upload -->
          <div>
            <label class="block text-sm font-bold text-secondary-blue mb-2">Doctor's Prescription *</label>
            
            <!-- Upload area (show when no file) -->
            <div v-if="!prescriptionFile" class="relative">
              <input type="file" accept="image/*,application/pdf" @change="handlePrescriptionUpload" class="hidden" id="prescription-upload" />
              <label for="prescription-upload" class="flex items-center justify-center w-full px-4 py-8 border-2 border-dashed border-purple-300 rounded-xl hover:border-purple-500 hover:bg-purple-50 transition-all cursor-pointer group">
                <div class="text-center">
                  <svg class="w-12 h-12 mx-auto text-purple-400 group-hover:text-purple-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                  </svg>
                  <p class="text-sm font-semibold text-purple-600">Click to upload prescription</p>
                  <p class="text-xs text-dark-gray mt-1">PDF, JPG, PNG (Max 10MB)</p>
                </div>
              </label>
            </div>
            
            <!-- File preview (show when file uploaded) -->
            <div v-else class="bg-green-50 border-2 border-green-300 rounded-xl p-4">
              <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3 flex-1">
                  <svg class="w-6 h-6 text-green-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-semibold text-green-800 truncate">{{ prescriptionFileName }}</p>
                    <p class="text-xs text-green-600">{{ formatFileSize(prescriptionFile.size) }}</p>
                  </div>
                </div>
                <button 
                  @click="removePrescription" 
                  type="button"
                  class="ml-3 p-2 hover:bg-red-100 rounded-lg transition-colors group"
                  title="Remove file"
                >
                  <svg class="w-5 h-5 text-red-600 group-hover:text-red-700" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Submit Button - BIG and BOLD with Cancel option -->
      <div class="pt-4">
        <button
          v-if="!submitting"
          type="submit"
          class="w-full py-6 px-8 btn-primary text-xl font-bold rounded-2xl shadow-2xl flex items-center justify-center space-x-4 transform hover:scale-105 transition-all duration-300"
        >
          <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span>Submit for AI Verification</span>
        </button>

        <!-- Processing state with Cancel button -->
        <div v-else class="space-y-4">
          <div class="w-full py-6 px-8 bg-gray-100 text-xl font-bold rounded-2xl flex items-center justify-center space-x-4">
            <div class="animate-spin rounded-full h-8 w-8 border-4 border-accent-orange border-t-transparent"></div>
            <span class="text-secondary-blue">Analyzing with AI...</span>
          </div>
          <button
            @click.prevent="cancelSubmission"
            type="button"
            class="w-full py-3 px-6 bg-white border-2 border-red-500 text-red-600 font-semibold rounded-xl hover:bg-red-50 transition-colors flex items-center justify-center space-x-2"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
            <span>Cancel Submission</span>
          </button>
        </div>
      </div>

      <!-- Result Message - BIG and PROMINENT -->
      <transition name="fade">
        <div v-if="result" class="p-8 rounded-2xl border-4 shadow-2xl" :class="{
          'bg-green-50 border-success-green': (result.final_status || result.prediction_label) === 'genuine',
          'bg-red-50 border-danger-red': (result.final_status || result.prediction_label) === 'fake'
        }">
          <div class="flex items-start space-x-4">
            <div class="flex-shrink-0">
              <svg v-if="(result.final_status || result.prediction_label) === 'genuine'" class="w-16 h-16 text-success-green" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              <svg v-else class="w-16 h-16 text-danger-red" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
              </svg>
            </div>
            <div class="flex-1">
              <h4 class="text-3xl font-bold mb-3" :class="{
                'text-success-green': (result.final_status || result.prediction_label) === 'genuine',
                'text-danger-red': (result.final_status || result.prediction_label) === 'fake'
              }">
                {{ (result.final_status || result.prediction_label) === 'genuine' ? '✅ Claim Approved!' : '❌ Claim Rejected' }}
              </h4>
              <p class="text-lg mb-4" :class="{
                'text-green-700': (result.final_status || result.prediction_label) === 'genuine',
                'text-red-700': (result.final_status || result.prediction_label) === 'fake'
              }">
                {{ result.message }}
              </p>
              
              <!-- Score Breakdown -->
              <div class="flex flex-wrap items-center gap-3">
                <!-- Combined Score (if images were verified) -->
                <span v-if="result.combined_score !== undefined" class="badge text-base px-4 py-2 font-bold" :class="{
                  'badge-success': result.combined_score >= 80,
                  'badge-danger': result.combined_score < 80
                }">
                  🎯 Combined Score: {{ result.combined_score.toFixed(1) }}%
                </span>
                
                <!-- ML Confidence -->
                <span class="badge badge-info text-base px-4 py-2">
                  🤖 ML: {{ (result.confidence * 100).toFixed(1) }}%
                </span>
                
                <!-- Image Verification Score (if available) -->
                <span v-if="result.image_verification" class="badge badge-warning text-base px-4 py-2">
                  📸 Image: {{ result.image_verification.score.toFixed(1) }}%
                </span>
                
                <!-- Claim ID -->
                <span class="badge badge-info text-base px-4 py-2">
                  Claim ID: #{{ result.claim_id }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- Error Message -->
      <transition name="fade">
        <div v-if="error" class="p-6 bg-red-50 border-2 border-red-200 rounded-xl">
          <div class="flex items-start">
            <svg class="w-8 h-8 text-danger-red mt-0.5 mr-4" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
            <div>
              <p class="font-bold text-danger-red text-lg">Error Submitting Claim</p>
              <p class="text-red-700">{{ error }}</p>
            </div>
          </div>
        </div>
      </transition>
    </form>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
import { api } from '../api.js';
import { useToast } from '../composables/useToast';

const props = defineProps({
  userId: {
    type: Number,
    required: true,
  },
  userData: {
    type: Object,
    default: null,
  },
});

const emit = defineEmits(['claim-submitted']);

const { showSuccess, showError } = useToast();

const today = new Date().toISOString().split('T')[0];

const formData = ref({
  user_id: props.userId,
  amount_billed: null,
  // age and gender are now auto-fetched from userData in backend
  diagnosis: '',
  admission_date: '',
  discharge_date: '',
});

const submitting = ref(false);
const result = ref(null);
const error = ref('');
let abortController = null; // For canceling requests

// Document upload states
const receiptFile = ref(null);
const prescriptionFile = ref(null);
const receiptFileName = ref('');
const prescriptionFileName = ref('');

// File upload handlers
const handleReceiptUpload = (event) => {
  const file = event.target.files[0];
  if (file) {
    if (file.size > 10 * 1024 * 1024) {
      showError('File size must be less than 10MB');
      event.target.value = '';
      return;
    }
    receiptFile.value = file;
    receiptFileName.value = file.name;
    console.log('Receipt uploaded:', file.name, formatFileSize(file.size));
  }
};

const handlePrescriptionUpload = (event) => {
  const file = event.target.files[0];
  if (file) {
    if (file.size > 10 * 1024 * 1024) {
      showError('File size must be less than 10MB');
      event.target.value = '';
      return;
    }
    prescriptionFile.value = file;
    prescriptionFileName.value = file.name;
    console.log('Prescription uploaded:', file.name, formatFileSize(file.size));
  }
};

// Remove file functions
const removeReceipt = () => {
  receiptFile.value = null;
  receiptFileName.value = '';
  const input = document.getElementById('receipt-upload');
  if (input) input.value = '';
  console.log('Receipt removed');
};

const removePrescription = () => {
  prescriptionFile.value = null;
  prescriptionFileName.value = '';
  const input = document.getElementById('prescription-upload');
  if (input) input.value = '';
  console.log('Prescription removed');
};

// File size formatter
const formatFileSize = (bytes) => {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
};

const daysHospitalized = computed(() => {
  if (!formData.value.admission_date || !formData.value.discharge_date) return 0;
  const admission = new Date(formData.value.admission_date);
  const discharge = new Date(formData.value.discharge_date);
  const diffTime = Math.abs(discharge - admission);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  return diffDays;
});

watch(() => props.userId, (newUserId) => {
  formData.value.user_id = newUserId;
});

const cancelSubmission = () => {
  if (abortController) {
    abortController.abort();
    abortController = null;
  }
  submitting.value = false;
  error.value = '';
  showError('Claim submission cancelled');
  console.log('🚫 Submission cancelled by user');
};

const submitClaim = async () => {
  try {
    submitting.value = true;
    error.value = '';
    result.value = null;

    // Create abort controller for this request
    abortController = new AbortController();

    // Prepare data for ML service (only fields it expects)
    const mlData = {
      user_id: props.userId,
      amount_billed: formData.value.amount_billed,
      age: formData.value.age,
      gender: formData.value.gender,
      diagnosis: formData.value.diagnosis,
    };

    console.log('📤 Step 1: Submitting claim for ML prediction...');
    
    // Step 1: Submit to ML service for initial prediction
    const mlResponse = await api.submitClaim(mlData, { signal: abortController.signal });
    
    console.log('✅ ML Prediction complete. Claim ID:', mlResponse.claim_id);
    console.log('   ML Status:', mlResponse.prediction_label, `(${(mlResponse.confidence * 100).toFixed(1)}%)`);
    
    // If we get here, the request wasn't cancelled
    abortController = null;
    
    let finalResult = mlResponse;

    // Step 2: If both prescription and receipt are uploaded, verify images
    if (prescriptionFile.value && receiptFile.value) {
      console.log('📸 Step 2: Uploading images for AI verification...');
      
      try {
        const imageResponse = await api.verifyImages(
          mlResponse.claim_id,
          prescriptionFile.value,
          receiptFile.value
        );
        
        console.log('✅ Image Verification complete.');
        console.log('   Image Score:', `${imageResponse.image_verification.score.toFixed(1)}%`);
        console.log('   Combined Score:', `${imageResponse.combined_score.toFixed(1)}%`);
        console.log('   Final Status:', imageResponse.final_status);
        
        // Update result with image verification data
        finalResult = {
          ...mlResponse,
          image_verification: imageResponse.image_verification,
          combined_score: imageResponse.combined_score,
          final_status: imageResponse.final_status,
          message: imageResponse.message
        };
        
        // Show success/error based on combined score
        if (imageResponse.final_status === 'genuine') {
          showSuccess(`🎉 Claim approved! Combined AI Score: ${imageResponse.combined_score.toFixed(1)}%`);
        } else {
          showError(`⚠️ Claim rejected. Combined AI Score: ${imageResponse.combined_score.toFixed(1)}% (below 80% threshold)`);
        }
      } catch (imageErr) {
        console.error('Image verification failed:', imageErr);
        showError('⚠️ Image verification failed, but ML prediction completed: ' + (imageErr.response?.data?.detail || imageErr.message));
        // Still show ML result even if image verification fails
      }
    } else {
      console.log('ℹ️ No images uploaded. Using ML prediction only.');
      
      // Show success/error based on ML prediction only
      if (mlResponse.prediction_label === 'genuine') {
        showSuccess('🎉 Claim approved by ML! Upload images for higher accuracy.');
      } else {
        showError('⚠️ Claim rejected by ML verification.');
      }
    }
    
    result.value = finalResult;

    // Emit event to parent
    setTimeout(() => {
      emit('claim-submitted');
    }, 2000);

  } catch (err) {
    // Check if error was due to cancellation
    if (err.name === 'AbortError') {
      console.log('Request was cancelled');
      return; // Don't show error for cancelled requests
    }

    const errorMessage = err.response?.data?.detail || err.message;
    error.value = errorMessage;
    showError(errorMessage);
    console.error('Claim submission error:', err);
  } finally {
    if (abortController) {
      abortController = null;
    }
    submitting.value = false;
  }
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
