-- HealthTrust Insurance dApp - PostgreSQL Database Schema
-- Migration: 001_healthtrust_schema.sql
-- Database: healthtrust_db

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================
-- 1. USERS TABLE
-- ==============================================
CREATE TABLE users (
    user_uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wallet_address VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    full_name VARCHAR(255),
    date_of_birth DATE,
    gender VARCHAR(20) CHECK (gender IN ('male', 'female', 'other')),
    phone_number VARCHAR(20),
    
    -- Insurance Policy Info
    policy_number VARCHAR(50) UNIQUE,
    policy_expiry_date DATE,
    premium_amount DECIMAL(10, 2),
    coverage_amount DECIMAL(12, 2),
    
    -- Privacy: NEVER go to blockchain
    ssn_hash VARCHAR(64),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country VARCHAR(100),
    
    is_registered BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_users_wallet ON users(wallet_address);
CREATE INDEX idx_users_policy ON users(policy_number);
CREATE INDEX idx_users_email ON users(email);

-- ==============================================
-- 2. INSURANCE CLAIMS TABLE
-- ==============================================
CREATE TABLE insurance_claims (
    claim_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_uuid UUID REFERENCES users(user_uuid) ON DELETE CASCADE,
    
    -- PRIVATE DATA (Local DB Only)
    patient_fullname VARCHAR(255) NOT NULL,
    patient_age INT NOT NULL,
    patient_gender VARCHAR(20),
    
    -- Detailed Medical Info (PRIVATE)
    diagnosis_detailed TEXT NOT NULL,
    hospital_name VARCHAR(255),
    doctor_name VARCHAR(255),
    admission_date DATE,
    discharge_date DATE,
    stay_duration INT,
    
    -- Treatment Details (PRIVATE)
    treatment_description TEXT,
    prescription_details TEXT,
    medical_record_number VARCHAR(100),
    
    -- Financial (PRIVATE)
    amount_billed DECIMAL(10, 2) NOT NULL,
    amount_approved DECIMAL(10, 2),
    
    -- PUBLIC DATA (Goes to Blockchain - Anonymized)
    patient_hash VARCHAR(64) NOT NULL,
    diagnosis_category VARCHAR(100),
    age_range VARCHAR(20),
    amount_range VARCHAR(50),
    
    -- ML Analysis
    ml_status VARCHAR(50) DEFAULT 'pending' 
        CHECK (ml_status IN ('pending', 'genuine', 'fake')),
    fraud_score DECIMAL(5, 4),
    ml_prediction TEXT,
    ml_confidence DECIMAL(5, 4),
    
    -- Blockchain Link
    latest_tx_hash TEXT,
    payout_status VARCHAR(50) DEFAULT 'pending'
        CHECK (payout_status IN ('pending', 'approved', 'rejected', 'trigger', 'completed')),
    payout_tx_hash TEXT,
    
    -- Status
    claim_status VARCHAR(50) DEFAULT 'submitted'
        CHECK (claim_status IN ('submitted', 'under_review', 'approved', 'rejected', 'paid')),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_claims_user ON insurance_claims(user_uuid);
CREATE INDEX idx_claims_status ON insurance_claims(ml_status);
CREATE INDEX idx_claims_payout ON insurance_claims(payout_status);
CREATE INDEX idx_claims_patient_hash ON insurance_claims(patient_hash);

-- ==============================================
-- 3. CLAIM TRANSACTIONS TABLE
-- ==============================================
CREATE TABLE claim_transactions (
    transaction_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    claim_id UUID REFERENCES insurance_claims(claim_id) ON DELETE CASCADE,
    user_uuid UUID REFERENCES users(user_uuid) ON DELETE CASCADE,
    
    -- Transaction Type
    transaction_type VARCHAR(50) NOT NULL
        CHECK (transaction_type IN ('claim_submission', 'payout', 'rejection')),
    
    -- Blockchain Data (PUBLIC)
    tx_hash TEXT NOT NULL,
    block_height BIGINT,
    block_timestamp TIMESTAMP WITH TIME ZONE,
    confirmations INT DEFAULT 0,
    
    -- Metadata Sent to Blockchain (Anonymized)
    blockchain_metadata JSONB NOT NULL,
    
    -- Network Info
    network VARCHAR(20) DEFAULT 'preprod'
        CHECK (network IN ('mainnet', 'preprod', 'preview')),
    explorer_url TEXT,
    
    -- Fees
    gas_fees BIGINT,
    
    status VARCHAR(50) DEFAULT 'pending'
        CHECK (status IN ('pending', 'confirmed', 'failed')),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tx_claim ON claim_transactions(claim_id);
CREATE INDEX idx_tx_hash ON claim_transactions(tx_hash);
CREATE INDEX idx_tx_user ON claim_transactions(user_uuid);
CREATE INDEX idx_tx_type ON claim_transactions(transaction_type);

-- ==============================================
-- 4. PENDING PAYOUTS TABLE
-- ==============================================
CREATE TABLE pending_payouts (
    payout_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    claim_id UUID REFERENCES insurance_claims(claim_id) ON DELETE CASCADE,
    user_uuid UUID REFERENCES users(user_uuid) ON DELETE CASCADE,
    
    -- Payout Details
    payout_amount DECIMAL(10, 2) NOT NULL,
    wallet_address VARCHAR(255) NOT NULL,
    
    -- Queue Status
    queue_status VARCHAR(50) DEFAULT 'queued'
        CHECK (queue_status IN ('queued', 'processing', 'completed', 'failed')),
    
    -- Metadata for Blockchain (Anonymized)
    metadata_json JSONB NOT NULL,
    
    -- Batch Info
    batch_id UUID,
    batch_position INT,
    
    -- Results
    tx_hash TEXT,
    error_message TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_payouts_status ON pending_payouts(queue_status);
CREATE INDEX idx_payouts_batch ON pending_payouts(batch_id);
CREATE INDEX idx_payouts_claim ON pending_payouts(claim_id);

-- ==============================================
-- 5. SESSIONS TABLE
-- ==============================================
CREATE TABLE sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_uuid UUID REFERENCES users(user_uuid) ON DELETE CASCADE,
    
    -- Session Token
    session_token TEXT UNIQUE NOT NULL,
    
    -- OTP for wallet verification
    otp_code VARCHAR(60),
    otp_attempts INT DEFAULT 0,
    otp_expires_at TIMESTAMP WITH TIME ZONE,
    
    -- Session Metadata
    user_agent TEXT,
    ip_address INET,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_sessions_token ON sessions(session_token);
CREATE INDEX idx_sessions_user ON sessions(user_uuid);
CREATE INDEX idx_sessions_expiry ON sessions(expires_at);

-- ==============================================
-- 6. BLOCKCHAIN TRANSACTIONS TABLE
-- ==============================================
CREATE TABLE blockchain_transactions (
    tx_hash TEXT PRIMARY KEY,
    block_height BIGINT NOT NULL,
    block_hash TEXT NOT NULL,
    block_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    slot BIGINT NOT NULL,
    confirmations INT NOT NULL DEFAULT 0,
    size INT NOT NULL,
    gas_fees BIGINT NOT NULL,
    total_output BIGINT NOT NULL,
    network VARCHAR(20) NOT NULL DEFAULT 'preprod',
    status VARCHAR(20) NOT NULL DEFAULT 'confirmed',
    explorer_url TEXT NOT NULL,
    
    -- Full Metadata from Cardano (PUBLIC data only)
    metadata JSONB NOT NULL,
    
    -- Stats
    claim_count INT NOT NULL DEFAULT 0,
    
    fetched_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_blockchain_height ON blockchain_transactions(block_height);
CREATE INDEX idx_blockchain_network ON blockchain_transactions(network);
CREATE INDEX idx_blockchain_metadata_gin ON blockchain_transactions USING gin(metadata);

-- ==============================================
-- 7. CLAIM HISTORY TABLE (Audit Trail)
-- ==============================================
CREATE TABLE claim_history (
    history_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    claim_id UUID REFERENCES insurance_claims(claim_id) ON DELETE CASCADE,
    user_uuid UUID REFERENCES users(user_uuid) ON DELETE CASCADE,
    
    -- What changed
    action VARCHAR(100) NOT NULL,
    
    -- Old and New Values (JSON)
    old_values JSONB,
    new_values JSONB,
    
    -- Context
    performed_by VARCHAR(100),
    tx_hash TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_history_claim ON claim_history(claim_id);
CREATE INDEX idx_history_action ON claim_history(action);
CREATE INDEX idx_history_created ON claim_history(created_at);

-- ==============================================
-- TRIGGERS
-- ==============================================

-- Auto-update timestamps
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_modtime
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_claims_modtime
BEFORE UPDATE ON insurance_claims
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_blockchain_modtime
BEFORE UPDATE ON blockchain_transactions
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

-- ==============================================
-- INITIAL DATA / SEED (Optional)
-- ==============================================

-- You can add seed data here if needed
-- Example:
-- INSERT INTO users (wallet_address, email, full_name) VALUES
-- ('addr_test1...', 'test@example.com', 'Test User');

-- ==============================================
-- COMPLETION MESSAGE
-- ==============================================
DO $$
BEGIN
    RAISE NOTICE 'HealthTrust database schema created successfully!';
    RAISE NOTICE 'Database: healthtrust_db';
    RAISE NOTICE 'Tables: 7';
    RAISE NOTICE 'Privacy: Sensitive data stays local, only anonymized data goes to blockchain';
END $$;
