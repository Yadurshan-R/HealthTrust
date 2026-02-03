-- Migration: Add image verification to claims table
-- Date: 2026-01-22
-- Description: Store prescription and receipt images in database with verification result

-- Add columns for images and verification
ALTER TABLE claims 
ADD COLUMN IF NOT EXISTS prescription_image BYTEA,
ADD COLUMN IF NOT EXISTS receipt_image BYTEA,
ADD COLUMN IF NOT EXISTS images VARCHAR(20);

-- Add comments
COMMENT ON COLUMN claims.prescription_image IS 'Prescription image binary data';
COMMENT ON COLUMN claims.receipt_image IS 'Receipt image binary data';
COMMENT ON COLUMN claims.images IS 'Image verification result: genuine or fake';
