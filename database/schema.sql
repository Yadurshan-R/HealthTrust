-- Cardano Insurance dApp Database Schema
-- PostgreSQL Schema for Users, Claims, and Public Payouts

-- Drop existing tables if they exist (for clean redeployment)
DROP TABLE IF EXISTS public_payouts CASCADE;
DROP TABLE IF EXISTS claims CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    wallet_address VARCHAR(255) UNIQUE NOT NULL,
    age INTEGER DEFAULT 30,
    gender VARCHAR(10) DEFAULT 'Male',
    expiry_date DATE NOT NULL,
    premium DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Claims Table
CREATE TABLE claims (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount_billed DECIMAL(10, 2) NOT NULL,
    age INTEGER NOT NULL CHECK (age > 0 AND age < 150),
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('Male', 'Female')),
    diagnosis VARCHAR(100) NOT NULL,
    ml_status VARCHAR(20) CHECK (ml_status IN ('genuine', 'fake', 'pending')),
    confidence DECIMAL(5, 4),
    images VARCHAR(20),
    image_score DECIMAL(5, 2),
    payout_status VARCHAR(20) DEFAULT 'pending' CHECK (payout_status IN ('pending', 'trigger', 'completed')),
    payout_address VARCHAR(255),
    tx_hash VARCHAR(255),
    block_height INTEGER,
    slot INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Public Payouts Table (Privacy-preserving public record)
CREATE TABLE public_payouts (
    id SERIAL PRIMARY KEY,
    hashed_user_id VARCHAR(64) NOT NULL,  -- Blake2b-256 hash of (name + email)
    amount DECIMAL(10, 2) NOT NULL,
    tx_hash VARCHAR(255) NOT NULL UNIQUE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_users_wallet ON users(wallet_address);
CREATE INDEX idx_claims_user ON claims(user_id);
CREATE INDEX idx_claims_payout_status ON claims(payout_status);
CREATE INDEX idx_claims_ml_status ON claims(ml_status);
CREATE INDEX idx_public_payouts_tx ON public_payouts(tx_hash);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_claims_updated_at BEFORE UPDATE ON claims
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE users IS 'Insurance policy holders with wallet addresses';
COMMENT ON TABLE claims IS 'Insurance claims with ML fraud detection status';
COMMENT ON TABLE public_payouts IS 'Privacy-preserving public record of payouts on Cardano blockchain';
COMMENT ON COLUMN public_payouts.hashed_user_id IS 'Blake2b-256 hash of (name + email) for privacy';
COMMENT ON COLUMN claims.ml_status IS 'ML model prediction: genuine, fake, or pending';
COMMENT ON COLUMN claims.payout_status IS 'Payout workflow: pending, trigger (awaiting blockchain), completed';
