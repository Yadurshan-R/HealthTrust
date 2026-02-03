-- Add payout_date column if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'claims' AND column_name = 'payout_date'
    ) THEN
        ALTER TABLE claims ADD COLUMN payout_date TIMESTAMP;
    END IF;
END $$;

-- Create or replace the view
CREATE OR REPLACE VIEW claim_transactions AS
SELECT 
    c.id AS claim_id,
    c.user_id,
    c.amount_billed,
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

SELECT 'Database schema updated successfully!' AS status;
