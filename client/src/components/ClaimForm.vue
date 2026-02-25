<template>
  <div class="bg-white rounded-2xl shadow-xl overflow-hidden border border-gray-100">
    <!-- Header with gradient -->
    <div class="bg-gradient-to-r from-main-blue to-main-green p-6 sm:p-8 text-white">
      <div class="flex items-center space-x-4">
        <div class="w-14 h-14 rounded-2xl bg-white/20 backdrop-blur flex items-center justify-center">
          <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <div>
          <h3 class="text-xl sm:text-2xl font-extrabold">Submit Insurance Claim</h3>
          <p class="text-white/70 text-sm mt-0.5">AI-powered fraud detection & instant verification</p>
        </div>
      </div>

      <!-- Step Indicator -->
      <div class="flex items-center justify-between mt-6 sm:mt-8 px-2">
        <div v-for="(step, idx) in steps" :key="idx" class="flex items-center" :class="idx < steps.length - 1 ? 'flex-1' : ''">
          <div class="flex flex-col items-center">
            <div
              class="w-8 h-8 sm:w-9 sm:h-9 rounded-full flex items-center justify-center text-xs sm:text-sm font-bold transition-all duration-300"
              :class="currentStep > idx ? 'bg-white text-main-green' : currentStep === idx ? 'bg-white text-main-blue ring-4 ring-white/30' : 'bg-white/20 text-white/60'"
            >
              <svg v-if="currentStep > idx" class="w-4 h-4 sm:w-5 sm:h-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
              </svg>
              <span v-else>{{ idx + 1 }}</span>
            </div>
            <span class="text-[10px] sm:text-xs mt-1.5 font-medium whitespace-nowrap" :class="currentStep >= idx ? 'text-white' : 'text-white/40'">{{ step }}</span>
          </div>
          <div v-if="idx < steps.length - 1" class="flex-1 h-0.5 mx-2 sm:mx-3 rounded-full transition-all duration-500" :class="currentStep > idx ? 'bg-white' : 'bg-white/20'"></div>
        </div>
      </div>
    </div>

    <form @submit.prevent="submitClaim" class="p-5 sm:p-8">
      <!-- Step 0: Patient Info (always visible as context) -->
      <div class="mb-6">
        <div class="flex items-center space-x-2 mb-3">
          <svg class="w-5 h-5 text-main-blue" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
          <h4 class="text-sm font-bold text-main-blue uppercase tracking-wider">Patient Information</h4>
          <span class="ml-auto px-2.5 py-0.5 bg-blue-100 text-main-blue text-[10px] font-bold rounded-full">AUTO</span>
        </div>
        <div class="grid grid-cols-3 gap-2 sm:gap-3">
          <div class="bg-gray-50 rounded-xl px-3 py-2.5 sm:px-4 sm:py-3 border border-gray-100">
            <div class="text-[10px] text-dark-gray uppercase tracking-wider mb-0.5">Name</div>
            <div class="text-sm sm:text-base font-semibold text-gray-900 truncate">{{ userData?.name || '—' }}</div>
          </div>
          <div class="bg-gray-50 rounded-xl px-3 py-2.5 sm:px-4 sm:py-3 border border-gray-100">
            <div class="text-[10px] text-dark-gray uppercase tracking-wider mb-0.5">Age</div>
            <div class="text-sm sm:text-base font-semibold text-gray-900">{{ userData?.age || '—' }}</div>
          </div>
          <div class="bg-gray-50 rounded-xl px-3 py-2.5 sm:px-4 sm:py-3 border border-gray-100">
            <div class="text-[10px] text-dark-gray uppercase tracking-wider mb-0.5">Gender</div>
            <div class="text-sm sm:text-base font-semibold text-gray-900 capitalize">{{ userData?.gender || '—' }}</div>
          </div>
        </div>
      </div>

      <div class="border-t border-gray-100 pt-6 space-y-6">

        <!-- Step 1: Hospital Stay Details -->
        <div v-show="currentStep === 0" class="space-y-5 animate-fadeIn">
          <div class="flex items-center space-x-2 mb-1">
            <div class="w-7 h-7 rounded-lg bg-accent-orange/10 flex items-center justify-center">
              <svg class="w-4 h-4 text-accent-orange" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
            </div>
            <h4 class="text-base sm:text-lg font-bold text-gray-900">Hospital Stay Details</h4>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label class="block text-xs font-semibold text-secondary-blue mb-1.5 uppercase tracking-wider">Admission Date *</label>
              <input
                v-model="formData.admission_date"
                type="date"
                required
                class="input-base"
                :max="formData.discharge_date || today"
              />
            </div>
            <div>
              <label class="block text-xs font-semibold text-secondary-blue mb-1.5 uppercase tracking-wider">Discharge Date *</label>
              <input
                v-model="formData.discharge_date"
                type="date"
                required
                class="input-base"
                :min="formData.admission_date"
                :max="today"
              />
            </div>
          </div>

          <transition name="fade">
            <div v-if="daysHospitalized > 0" class="flex items-center space-x-3 p-3.5 bg-blue-50 rounded-xl border border-blue-100">
              <div class="w-9 h-9 rounded-full bg-main-blue/10 flex items-center justify-center flex-shrink-0">
                <svg class="w-5 h-5 text-main-blue" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd" />
                </svg>
              </div>
              <div>
                <div class="text-xs text-secondary-blue">Duration</div>
                <div class="text-xl font-bold text-main-blue">{{ daysHospitalized }} {{ daysHospitalized === 1 ? 'Day' : 'Days' }}</div>
              </div>
            </div>
          </transition>

          <div class="pt-2">
            <button type="button" @click="nextStep" :disabled="!formData.admission_date || !formData.discharge_date"
              class="w-full btn-primary py-3.5 flex items-center justify-center space-x-2 disabled:opacity-40 disabled:cursor-not-allowed">
              <span>Continue to Diagnosis</span>
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" /></svg>
            </button>
          </div>
        </div>

        <!-- Step 2: Diagnosis & Amount -->
        <div v-show="currentStep === 1" class="space-y-5 animate-fadeIn">
          <div class="flex items-center space-x-2 mb-1">
            <div class="w-7 h-7 rounded-lg bg-main-green/10 flex items-center justify-center">
              <svg class="w-4 h-4 text-main-green" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <h4 class="text-base sm:text-lg font-bold text-gray-900">Treatment & Billing</h4>
          </div>

          <div>
            <label class="block text-xs font-semibold text-secondary-blue mb-1.5 uppercase tracking-wider">Primary Diagnosis *</label>
            <select v-model="formData.diagnosis" required class="input-base">
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

          <div>
            <label class="block text-xs font-semibold text-secondary-blue mb-1.5 uppercase tracking-wider">Total Amount Billed ($) *</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <span class="text-dark-gray text-xl font-bold">$</span>
              </div>
              <input
                v-model.number="formData.amount_billed"
                type="number"
                step="0.01"
                min="0"
                required
                class="input-base pl-12 text-xl font-bold text-main-green"
                placeholder="0.00"
              />
            </div>
            <p class="text-[10px] sm:text-xs text-dark-gray mt-1.5">Total hospital bill in USD including treatments, room charges, and medications</p>
          </div>

          <!-- Live ADA Conversion -->
          <transition name="fade">
            <div v-if="formData.amount_billed > 0" class="p-4 rounded-xl border" :class="adaPrice ? 'bg-blue-50 border-blue-200' : 'bg-gray-50 border-gray-200'">
              <div v-if="adaPriceLoading" class="flex items-center space-x-2 text-sm text-secondary-blue">
                <div class="animate-spin rounded-full h-4 w-4 border-2 border-main-blue border-t-transparent"></div>
                <span>Fetching live ADA rate...</span>
              </div>
              <div v-else-if="adaPrice" class="space-y-2">
                <div class="flex items-center space-x-2">
                  <div class="w-7 h-7 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
                    <span class="text-sm font-bold text-main-blue">₳</span>
                  </div>
                  <div>
                    <p class="text-[10px] text-secondary-blue uppercase tracking-wider font-semibold">Live Exchange Rate</p>
                    <p class="text-sm font-bold text-main-blue">1 ADA = ${{ adaPrice.toFixed(4) }} USD</p>
                  </div>
                </div>
                <div class="flex items-center justify-between pt-2 border-t border-blue-200">
                  <span class="text-xs text-secondary-blue font-medium">Your total for this transaction</span>
                  <span class="text-lg font-extrabold text-main-green">₳{{ adaAmount.toFixed(2) }} ADA</span>
                </div>
              </div>
              <div v-else class="text-xs text-red-500">
                ⚠️ Unable to fetch ADA rate. Please try again.
                <button @click="fetchAdaPrice" type="button" class="ml-2 underline text-main-blue">Retry</button>
              </div>
            </div>
          </transition>

          <div class="flex gap-3 pt-2">
            <button type="button" @click="prevStep"
              class="flex-1 py-3.5 border-2 border-gray-200 text-secondary-blue font-semibold rounded-xl hover:bg-gray-50 transition-all flex items-center justify-center space-x-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 17l-5-5m0 0l5-5m-5 5h12" /></svg>
              <span>Back</span>
            </button>
            <button type="button" @click="nextStep" :disabled="!formData.diagnosis || !formData.amount_billed"
              class="flex-[2] btn-primary py-3.5 flex items-center justify-center space-x-2 disabled:opacity-40 disabled:cursor-not-allowed">
              <span>Continue to Documents</span>
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" /></svg>
            </button>
          </div>
        </div>

        <!-- Step 3: Documents & Submit -->
        <div v-show="currentStep === 2" class="space-y-5 animate-fadeIn">
          <div class="flex items-center space-x-2 mb-1">
            <div class="w-7 h-7 rounded-lg bg-purple-500/10 flex items-center justify-center">
              <svg class="w-4 h-4 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
              </svg>
            </div>
            <h4 class="text-base sm:text-lg font-bold text-gray-900">Supporting Documents</h4>
            <span class="text-[10px] px-2 py-0.5 bg-red-100 text-red-700 rounded-full font-semibold">Required</span>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <!-- Receipt Upload -->
            <div>
              <label class="block text-xs font-semibold text-secondary-blue mb-1.5 uppercase tracking-wider">Hospital Receipt</label>
              <div v-if="!receiptFile" class="relative">
                <input type="file" accept="image/*,application/pdf" @change="handleReceiptUpload" class="hidden" id="receipt-upload" />
                <label for="receipt-upload" class="flex flex-col items-center justify-center w-full py-6 sm:py-8 border-2 border-dashed border-gray-200 rounded-xl hover:border-purple-400 hover:bg-purple-50/50 transition-all cursor-pointer group">
                  <div class="w-10 h-10 rounded-full bg-purple-100 group-hover:bg-purple-200 flex items-center justify-center mb-2 transition-colors">
                    <svg class="w-5 h-5 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                    </svg>
                  </div>
                  <p class="text-xs font-semibold text-purple-600">Upload receipt</p>
                  <p class="text-[10px] text-dark-gray mt-0.5">PDF, JPG, PNG (Max 10MB)</p>
                </label>
              </div>
              <div v-else class="bg-green-50 border border-green-200 rounded-xl p-3 sm:p-4">
                <div class="flex items-center justify-between">
                  <div class="flex items-center space-x-2.5 flex-1 min-w-0">
                    <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center flex-shrink-0">
                      <svg class="w-4 h-4 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                      </svg>
                    </div>
                    <div class="min-w-0">
                      <p class="text-xs font-semibold text-green-800 truncate">{{ receiptFileName }}</p>
                      <p class="text-[10px] text-green-600">{{ formatFileSize(receiptFile.size) }}</p>
                    </div>
                  </div>
                  <button @click="removeReceipt" type="button" class="p-1.5 hover:bg-red-100 rounded-lg transition-colors">
                    <svg class="w-4 h-4 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>

            <!-- Prescription Upload -->
            <div>
              <label class="block text-xs font-semibold text-secondary-blue mb-1.5 uppercase tracking-wider">Doctor's Prescription</label>
              <div v-if="!prescriptionFile" class="relative">
                <input type="file" accept="image/*,application/pdf" @change="handlePrescriptionUpload" class="hidden" id="prescription-upload" />
                <label for="prescription-upload" class="flex flex-col items-center justify-center w-full py-6 sm:py-8 border-2 border-dashed border-gray-200 rounded-xl hover:border-purple-400 hover:bg-purple-50/50 transition-all cursor-pointer group">
                  <div class="w-10 h-10 rounded-full bg-purple-100 group-hover:bg-purple-200 flex items-center justify-center mb-2 transition-colors">
                    <svg class="w-5 h-5 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                  </div>
                  <p class="text-xs font-semibold text-purple-600">Upload prescription</p>
                  <p class="text-[10px] text-dark-gray mt-0.5">PDF, JPG, PNG (Max 10MB)</p>
                </label>
              </div>
              <div v-else class="bg-green-50 border border-green-200 rounded-xl p-3 sm:p-4">
                <div class="flex items-center justify-between">
                  <div class="flex items-center space-x-2.5 flex-1 min-w-0">
                    <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center flex-shrink-0">
                      <svg class="w-4 h-4 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                      </svg>
                    </div>
                    <div class="min-w-0">
                      <p class="text-xs font-semibold text-green-800 truncate">{{ prescriptionFileName }}</p>
                      <p class="text-[10px] text-green-600">{{ formatFileSize(prescriptionFile.size) }}</p>
                    </div>
                  </div>
                  <button @click="removePrescription" type="button" class="p-1.5 hover:bg-red-100 rounded-lg transition-colors">
                    <svg class="w-4 h-4 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Summary Card -->
          <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
            <h5 class="text-xs font-bold text-secondary-blue uppercase tracking-wider mb-3">Claim Summary</h5>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-sm">
              <div>
                <div class="text-[10px] text-dark-gray">Dates</div>
                <div class="font-semibold text-gray-900">{{ daysHospitalized }} day{{ daysHospitalized !== 1 ? 's' : '' }}</div>
              </div>
              <div>
                <div class="text-[10px] text-dark-gray">Diagnosis</div>
                <div class="font-semibold text-gray-900 truncate">{{ formData.diagnosis || '—' }}</div>
              </div>
              <div>
                <div class="text-[10px] text-dark-gray">Amount (USD)</div>
                <div class="font-bold text-main-green">${{ formData.amount_billed || '0' }}</div>
                <div v-if="adaPrice && formData.amount_billed" class="text-[10px] text-main-blue font-semibold">≈ ₳{{ adaAmount.toFixed(2) }} ADA</div>
              </div>
              <div>
                <div class="text-[10px] text-dark-gray">Documents</div>
                <div class="font-semibold text-gray-900">{{ (receiptFile ? 1 : 0) + (prescriptionFile ? 1 : 0) }} / 2</div>
              </div>
            </div>
          </div>

          <!-- Missing documents warning -->
          <transition name="fade">
            <div v-if="!receiptFile || !prescriptionFile" class="flex items-start space-x-3 p-3.5 bg-amber-50 rounded-xl border border-amber-200">
              <svg class="w-5 h-5 text-amber-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
              </svg>
              <div>
                <p class="text-sm font-semibold text-amber-800">Documents Required</p>
                <p class="text-xs text-amber-700 mt-0.5">Please upload both the <strong>Hospital Receipt</strong> and <strong>Doctor's Prescription</strong> to submit your claim.</p>
              </div>
            </div>
          </transition>

          <!-- Submit / Cancel buttons -->
          <div class="flex gap-3 pt-2">
            <button type="button" @click="prevStep"
              class="flex-1 py-3.5 border-2 border-gray-200 text-secondary-blue font-semibold rounded-xl hover:bg-gray-50 transition-all flex items-center justify-center space-x-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 17l-5-5m0 0l5-5m-5 5h12" /></svg>
              <span>Back</span>
            </button>

            <button
              v-if="!submitting"
              type="submit"
              :disabled="!receiptFile || !prescriptionFile"
              class="flex-[2] btn-success py-3.5 text-base font-bold flex items-center justify-center space-x-2 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span>Submit for AI Verification</span>
            </button>

            <div v-else class="flex-[2] flex flex-col gap-2">
              <div class="py-3.5 bg-gray-100 font-bold rounded-xl flex items-center justify-center space-x-3">
                <div class="animate-spin rounded-full h-5 w-5 border-[3px] border-accent-orange border-t-transparent"></div>
                <span class="text-secondary-blue text-sm">Analyzing with AI...</span>
              </div>
              <button @click.prevent="cancelSubmission" type="button"
                class="py-2 border-2 border-red-300 text-red-500 font-semibold rounded-xl hover:bg-red-50 transition-colors text-sm flex items-center justify-center space-x-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                <span>Cancel</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Result Message -->
      <transition name="fade">
        <div v-if="result" class="mt-6 p-5 sm:p-6 rounded-2xl border-2" :class="{
          'bg-green-50 border-success-green': (result.final_status || result.prediction_label) === 'genuine',
          'bg-red-50 border-danger-red': (result.final_status || result.prediction_label) === 'fake'
        }">
          <div class="flex items-start space-x-3 sm:space-x-4">
            <div class="flex-shrink-0 mt-0.5">
              <div class="w-12 h-12 rounded-full flex items-center justify-center" :class="{
                'bg-green-100': (result.final_status || result.prediction_label) === 'genuine',
                'bg-red-100': (result.final_status || result.prediction_label) === 'fake'
              }">
                <svg v-if="(result.final_status || result.prediction_label) === 'genuine'" class="w-7 h-7 text-success-green" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
                <svg v-else class="w-7 h-7 text-danger-red" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                </svg>
              </div>
            </div>
            <div class="flex-1 min-w-0">
              <h4 class="text-lg sm:text-xl font-bold mb-1" :class="{
                'text-success-green': (result.final_status || result.prediction_label) === 'genuine',
                'text-danger-red': (result.final_status || result.prediction_label) === 'fake'
              }">
                {{ (result.final_status || result.prediction_label) === 'genuine' ? 'Claim Approved!' : 'Claim Rejected' }}
              </h4>
              <p class="text-sm mb-3" :class="{
                'text-green-700': (result.final_status || result.prediction_label) === 'genuine',
                'text-red-700': (result.final_status || result.prediction_label) === 'fake'
              }">
                {{ result.message }}
              </p>
              <div class="flex flex-wrap items-center gap-2">
                <span v-if="result.combined_score !== undefined" class="badge text-xs px-3 py-1 font-bold" :class="{
                  'badge-success': result.combined_score >= 80,
                  'badge-danger': result.combined_score < 80
                }">
                  🎯 Combined: {{ result.combined_score.toFixed(1) }}%
                </span>
                <span class="badge badge-info text-xs px-3 py-1">
                  🤖 ML: {{ (result.confidence * 100).toFixed(1) }}%
                </span>
                <span v-if="result.image_verification" class="badge badge-warning text-xs px-3 py-1">
                  📸 Image: {{ result.image_verification.score.toFixed(1) }}%
                </span>
                <span class="badge badge-info text-xs px-3 py-1">
                  #{{ result.claim_id }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </transition>

      <!-- Error Message -->
      <transition name="fade">
        <div v-if="error" class="mt-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-start space-x-3">
          <svg class="w-5 h-5 text-danger-red mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
          </svg>
          <div>
            <p class="font-bold text-danger-red text-sm">Error Submitting Claim</p>
            <p class="text-red-700 text-sm">{{ error }}</p>
          </div>
        </div>
      </transition>
    </form>
  </div>
</template>

<script setup>
import { ref, watch, computed, onMounted } from 'vue';
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

// Step navigation
const currentStep = ref(0);
const steps = ['Hospital Stay', 'Diagnosis & Billing', 'Documents & Submit'];

const nextStep = () => {
  if (currentStep.value < steps.length - 1) currentStep.value++;
};
const prevStep = () => {
  if (currentStep.value > 0) currentStep.value--;
};

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

// ADA price state
const adaPrice = ref(null);          // Current ADA price in USD (e.g. 0.75)
const adaPriceLoading = ref(false);
const adaPriceError = ref(false);

// Computed: ADA equivalent of the USD amount
const adaAmount = computed(() => {
  if (!adaPrice.value || !formData.value.amount_billed) return 0;
  return formData.value.amount_billed / adaPrice.value;
});

// Fetch ADA price from backend
const fetchAdaPrice = async () => {
  adaPriceLoading.value = true;
  adaPriceError.value = false;
  try {
    const data = await api.getAdaPrice();
    adaPrice.value = data.ada_usd;
    console.log(`💱 ADA Price: $${data.ada_usd.toFixed(4)} USD`);
  } catch (err) {
    console.error('Failed to fetch ADA price:', err);
    adaPriceError.value = true;
  } finally {
    adaPriceLoading.value = false;
  }
};

// Fetch ADA price on mount and refresh every 60 seconds
onMounted(() => {
  fetchAdaPrice();
  setInterval(fetchAdaPrice, 60000);
});

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
    // Validate documents are uploaded
    if (!receiptFile.value || !prescriptionFile.value) {
      showError('Please upload both the Hospital Receipt and Doctor\'s Prescription');
      return;
    }

    // Validate ADA price is available for conversion
    if (!adaPrice.value) {
      showError('Unable to fetch ADA exchange rate. Please wait and try again.');
      await fetchAdaPrice();
      return;
    }

    submitting.value = true;
    error.value = '';
    result.value = null;

    // Create abort controller for this request
    abortController = new AbortController();

    // Calculate ADA amount at current rate
    const currentAdaAmount = formData.value.amount_billed / adaPrice.value;

    // Prepare data for ML service
    // amount_billed = USD (for ML model), amount_ada = ADA equivalent (for blockchain payout)
    const mlData = {
      user_id: props.userId,
      amount_billed: formData.value.amount_billed,
      amount_ada: parseFloat(currentAdaAmount.toFixed(4)),
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

    // Step 2: Verify images with AI (both files are mandatory)
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

.animate-fadeIn {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
