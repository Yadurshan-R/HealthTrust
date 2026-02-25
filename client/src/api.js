/**
 * API Client for Cardano Insurance dApp
 * Handles communication with ML Service (FastAPI backend)
 */

import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || '/api';

const apiClient = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json',
    },
    timeout: 10000,
});

// API Functions
export const api = {
    /**
     * Health check
     */
    async healthCheck() {
        const response = await apiClient.get('/');
        return response.data;
    },

    /**
     * Get current ADA/USD exchange rate
     */
    async getAdaPrice() {
        const response = await apiClient.get('/ada-price');
        return response.data;
    },

    /**
     * Get user by wallet address
     */
    async getUserByWallet(walletAddress) {
        const response = await apiClient.get(`/users/${walletAddress}`);
        return response.data;
    },

    /**
     * Submit claim for ML prediction
     */
    async submitClaim(claimData) {
        const response = await apiClient.post('/predict', claimData);
        return response.data;
    },

    /**
     * Trigger payout for genuine claim
     */
    async triggerPayout(claimId, walletAddress) {
        const response = await apiClient.put(`/claims/${claimId}/trigger-payout`, {
            payout_address: walletAddress
        });
        return response.data;
    },

    /**
     * Verify prescription and receipt images for a claim
     */
    async verifyImages(claimId, prescriptionFile, receiptFile) {
        const formData = new FormData();
        formData.append('claim_id', claimId);
        formData.append('prescription_image', prescriptionFile);
        formData.append('receipt_image', receiptFile);

        const response = await apiClient.post('/verify-images', formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
            timeout: 60000, // 60 seconds for image processing
        });
        return response.data;
    },

    /**
     * Get model information
     */
    async getModelInfo() {
        const response = await apiClient.get('/model/info');
        return response.data;
    },

    /**
     * Update user profile (name, age, gender)
     */
    async updateProfile(walletAddress, profileData) {
        const response = await apiClient.put(`/users/${walletAddress}/profile`, profileData);
        return response.data;
    },
};

// Error handling interceptor
apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        console.error('API Error:', error.response?.data || error.message);
        throw error;
    }
);

export default api;
