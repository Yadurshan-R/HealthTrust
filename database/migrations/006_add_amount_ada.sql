-- Migration 006: Add amount_ada column for ADA equivalent of USD claims
-- amount_billed = USD (used by ML model)
-- amount_ada = ADA equivalent at time of submission (used for blockchain payout)

ALTER TABLE claims ADD COLUMN IF NOT EXISTS amount_ada DECIMAL(12, 4);

COMMENT ON COLUMN claims.amount_billed IS 'Claim amount in USD (used by ML fraud detection model)';
COMMENT ON COLUMN claims.amount_ada IS 'ADA equivalent at time of submission (used for blockchain payout)';
