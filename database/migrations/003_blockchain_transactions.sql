-- Migration 003: Add blockchain transactions tracking table
-- This table stores on-chain transaction records from Cardano
-- Similar to CargoTrust's blockchain_transactions table

CREATE TABLE IF NOT EXISTS blockchain_transactions (
    -- Transaction identifiers
    tx_hash VARCHAR(64) PRIMARY KEY,
    claim_id INTEGER REFERENCES claims(id) ON DELETE CASCADE,
    
    -- Block information
    block_height BIGINT,
    block_hash VARCHAR(64),
    block_timestamp TIMESTAMP,
    slot BIGINT,
    
    -- Transaction status
    confirmations INTEGER DEFAULT 0,
    status VARCHAR(20) DEFAULT 'pending', -- pending, confirmed, failed
    
    -- Transaction details
    size INTEGER,                          -- Transaction size in bytes
    gas_fees BIGINT,                       -- Transaction fees in lovelace
    total_output BIGINT,                   -- Total output in lovelace
    
    -- Network and metadata
    network VARCHAR(20) DEFAULT 'preprod', -- preprod, mainnet
    metadata JSONB,                        -- Claim metadata (label 674)
    explorer_url TEXT,                     -- Link to CardanoScan
    
    -- Timestamps
    fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_blockchain_tx_claim_id ON blockchain_transactions(claim_id);
CREATE INDEX IF NOT EXISTS idx_blockchain_tx_status ON blockchain_transactions(status);
CREATE INDEX IF NOT EXISTS idx_blockchain_tx_timestamp ON blockchain_transactions(block_timestamp);

-- Add tx_hash column to claims table if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'claims' AND column_name = 'tx_hash'
    ) THEN
        ALTER TABLE claims ADD COLUMN tx_hash VARCHAR(64);
        ALTER TABLE claims ADD COLUMN payout_date TIMESTAMP;
        CREATE INDEX idx_claims_tx_hash ON claims(tx_hash);
    END IF;
END $$;

-- Function to update blockchain transaction status
CREATE OR REPLACE FUNCTION update_blockchain_tx_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at
DROP TRIGGER IF EXISTS blockchain_tx_update_timestamp ON blockchain_transactions;
CREATE TRIGGER blockchain_tx_update_timestamp
    BEFORE UPDATE ON blockchain_transactions
    FOR EACH ROW
    EXECUTE FUNCTION update_blockchain_tx_timestamp();

-- View for quick transaction overview
CREATE OR REPLACE VIEW claim_transactions AS
SELECT 
    c.id AS claim_id,
    c.user_id,
    c.claim_amount,
    c.ml_status,
    c.payout_status,
    bt.tx_hash,
    bt.confirmations,
    bt.status AS tx_status,
    bt.block_height,
    bt.explorer_url,
    bt.block_timestamp,
    c.created_at AS claim_created_at,
    c.payout_date
FROM claims c
LEFT JOIN blockchain_transactions bt ON c.tx_hash = bt.tx_hash
ORDER BY c.created_at DESC;

COMMENT ON TABLE blockchain_transactions IS 'Stores Cardano blockchain transaction records for insurance payouts';
COMMENT ON VIEW claim_transactions IS 'Combined view of claims and their blockchain transactions';
