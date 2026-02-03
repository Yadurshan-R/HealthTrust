# ⚠️ TREASURY WALLET - KEEP THIS SECURE!

## 🔐 Treasury Wallet Details

**24-Word Mnemonic (Recovery Phrase):**
```
couple learn peanut velvet hotel rule enter exit reason kite narrow dismiss then luxury rain travel dinner vendor true iron long usual skirt tackle
```

**Preprod Testnet Address:**
```
addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78
```

## 📋 What to Do Next

### 1. Fund the Treasury Wallet

**From Your Lace Wallet:**
- Open Lace Wallet (Preprod testnet)
- Send test tADA to: `addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78`
- Recommended amount: 1,000 - 5,000 tADA

### 2. Verify the Transaction

Check balance on Cardano Explorer:
https://preprod.cardanoscan.io/address/addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78

### 3. Update Configuration

Your `.env` file has been automatically updated with:
- `TREASURY_ADDRESS` - The Preprod address
- `TREASURY_MNEMONIC` - The 24-word phrase

### 4. Implement Transaction Building

The Go automation service needs to be updated to:
1. Load the mnemonic from `.env`
2. Build Cardano transactions using MeshJS or cardano-serialization-lib
3. Sign and submit to Preprod via Blockfrost

## ⚠️ SECURITY WARNINGS

1. **Never share the 24-word mnemonic** - Anyone with this can access the funds
2. **Backup the mnemonic** - Write it down on paper, store securely
3. **This is testnet only** - Do NOT use this wallet on mainnet
4. **Keep `treasury.mnemonic` secure** - Add to `.gitignore`

## 📁 Files Created

- `treasury.mnemonic` - 24-word recovery phrase
- `treasury.addr` - Preprod testnet address
- `../.env` - Updated with treasury details

---

**Created:** December 24, 2025
**Network:** Cardano Preprod Testnet
**Purpose:** Insurance claim payouts automation
