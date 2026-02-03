-- Sample data for testing Cardano Insurance dApp
-- For local testing, using mock wallet addresses

-- Option 1: Use these test addresses (safe for testing)
-- Option 2: Replace with your own Lace wallet addresses from Preprod testnet

INSERT INTO users (name, email, wallet_address, expiry_date, premium) VALUES
('Alice Johnson', 'alice@example.com', 'addr_test1qz2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3jcu5d8ps7zex2k2xt3uqxgjqnnj83ws8lhrn648jjxtwq2ytjqp', '2026-12-31', 250.00),
('Bob Smith', 'bob@example.com', 'addr_test1qpw0djgj0x59ngrjvqthn7enhvruxnsavsw5th63la3mjel3tkc974sr23jmlzgq5zda4gtv8k9cy38756r9y3qgmkqqjz6aa7', '2026-06-30', 180.50),
('Carol Williams', 'carol@example.com', 'addr_test1qq46g2ymhg2xkzf3l8xdxp5zqfzh63dnl6qzqvqxqhpx0r3jcu5d8ps7zex2k2xt3uqxgjqnnj83ws8lhrn648jjxtwqp6xmhd', '2025-12-31', 320.00);

-- Note: These are example Preprod testnet addresses
-- To use your own wallet:
-- 1. Open Lace Wallet and copy your Preprod testnet address
-- 2. Replace one of the addresses above with yours
-- 3. Re-run: sudo -u postgres psql insurance_dapp < database/seed.sql

-- Display inserted data
SELECT 
    id,
    name,
    email,
    LEFT(wallet_address, 20) || '...' as wallet_preview,
    expiry_date,
    premium
FROM users
ORDER BY id;
