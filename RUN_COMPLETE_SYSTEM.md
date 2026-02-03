# 🚀 Complete System Startup Guide

## Healthcare Insurance dApp with Blockchain Payouts

This guide shows you how to run the **complete system** with all components integrated:
- ✅ PostgreSQL Database
- ✅ Python ML Service (Fraud Detection)
- ✅ Node.js Blockchain Service (MeshSDK + Blockfrost)
- ✅ Go Automation Service (Payout Processor)
- ✅ Vue 3 Frontend (User Interface)

---

## 📋 Prerequisites Checklist

Before starting, make sure you have:

- [x] PostgreSQL running on port 5432
- [x] Database `HealthTrust` created with migrations applied
- [x] Blockfrost API key in `.env` file
- [x] Treasury wallet funded with test tADA
- [x] Node.js v18+ installed
- [x] Python 3.8+ installed
- [x] Go 1.20+ installed

---

## ⚡ Quick Start (All Services)

### Option 1: Manual Terminal Startup (Recommended)

Open **4 separate terminals** and run:

```bash
# Terminal 1: ML Service (Python - Port 8000)
cd /home/yadu/Development/My_FYP/model_1/ml-service
source venv/bin/activate
python app.py
# ✅ Should see: "Running on http://127.0.0.1:8000"

# Terminal 2: Blockchain Service (Node.js - Port 3001)  
cd /home/yadu/Development/My_FYP/model_1
npm run dev
# ✅ Should see: "🚀 Blockchain Service Started Successfully!"

# Terminal 3: Automation Service (Go - Background polling)
cd /home/yadu/Development/My_FYP/model_1/automation-service
go run *.go
# ✅ Should see: "🚀 Cardano Insurance Automation Service Started"
# ✅ Should see: "📡 Polling every 60 seconds for pending payouts..."

# Terminal 4: Frontend (Vue 3 - Port 5173)
cd /home/yadu/Development/My_FYP/model_1/client
npm run dev
# ✅ Should see: "Local: http://localhost:5173"
```

**Note:** Keep all 4 terminals running. The automation service processes payouts automatically every 60 seconds.

---

## 🔍 Detailed Service Breakdown

### 1️⃣ ML Service (Python - Port 8000)

**Purpose:** Predicts if insurance claims are genuine or fraudulent

**Startup:**
```bash
cd /home/yadu/Development/My_FYP/model_1/ml-service
source venv/bin/activate
python app.py
```

**Health Check:**
```bash
curl http://localhost:8000/health
# Expected: {"status": "healthy", "model": "loaded"}
```

**What it does:**
- Loads pre-trained Gradient Boosting model
- Receives claim data from frontend
- Returns prediction: `genuine` or `fake`
- Confidence score: 86.3% accuracy

---

### 2️⃣ Blockchain Service (Node.js - Port 3001)

**Purpose:** Handles all Cardano blockchain operations via MeshSDK

**Startup:**
```bash
cd /home/yadu/Development/My_FYP/model_1/blockchain-service
npm run dev
```

**Health Check:**
```bash
curl http://localhost:3001/health
# Expected: Treasury balance, address, network status
```

**Endpoints:**
- `GET /health` - Service status + treasury balance
- `GET /api/balance` - Treasury wallet balance  
- `POST /api/payout-transaction` - Submit payout to Cardano
- `GET /api/transaction/:txHash` - Get transaction details from Blockfrost

**What it does:**
- Initializes MeshWallet with treasury mnemonic
- Builds transactions with metadata (label 674)
- Submits signed transactions via Blockfrost
- Fetches transaction confirmations from Cardano network

**Configuration:**
```bash
# blockchain-service/.env
CARDANO_NETWORK=preprod
BLOCKFROST_API_KEY=preprodHeO1e9abeJx2hfKcP8gS9y6y1PhhibL0
TREASURY_MNEMONIC=couple learn peanut velvet...
PORT=3001
```

---

### 3️⃣ Go Automation Service (Port: None - Background Polling)

**Purpose:** Automatically processes approved claims every 60 seconds

**Startup:**
```bash
cd /home/yadu/Development/My_FYP/model_1/automation-service
go run *.go
```

**What it does:**
1. **Every 60 seconds:**
   - Queries database for claims with `payout_status = 'trigger'` and `ml_status = 'genuine'`
   - Converts ADA amount to lovelace (1 ADA = 1,000,000 lovelace)
   - Calls blockchain service `/api/payout-transaction`
   - Stores transaction hash in `blockchain_transactions` table
   - Updates claim status to `completed`
   - Adds record to `public_payouts` table

2. **Transaction Confirmations:**
   - Fetches latest confirmations for pending transactions
   - Updates `confirmations` count in database
   - Changes status from `pending` to `confirmed` after first block

**Files:**
- `database.go` - Database queries and connection
- `crypto.go` - Blake2b hashing for privacy
- `blockchain.go` - Blockchain service API calls
- `blockfrost.go` - Direct Blockfrost integration (future)

---

### 4️⃣ Frontend (Vue 3 - Port 5173)

**Purpose:** User interface for connecting wallets, submitting claims, and viewing blockchain transactions

**Startup:**
```bash
cd /home/yadu/Development/My_FYP/model_1/client
npm run dev
```

**Access:** http://localhost:5173

**Features:**
- **Wallet Connection:** Connect Nami, Eternl, or Lace wallets (top-right corner)
- **User Recognition:** Personalized greeting with user's policy info
- **Submit Claims:** Form with patient details and amount
- **ML Verification:** Real-time fraud detection results  
- **Trigger Payouts:** "Claim Amount" button for approved claims
- **Transaction Tracking:** View tx hash and CardanoScan explorer link
- **My Claims Dashboard:** View all claims with status indicators
- **Recent Activity:** Public payout feed (visible when not connected)

---

## 🔄 Payout Workflow Explained

**Understanding how payouts are processed:**

### Step-by-Step Process:

1. **User Submits Claim** → `payout_status = 'pending'`
   - Frontend sends claim data to ML service
   - ML service returns prediction (genuine/fake)
   - Claim stored in database

2. **User Clicks "Claim Amount"** → `payout_status = 'trigger'`
   - Available only for claims with `ml_status = 'genuine'`
   - Frontend calls backend API to update status
   - Claim is now queued for automation service

3. **Automation Service Processes** (every 60 seconds)
   - Queries database for `payout_status = 'trigger'`
   - Calls blockchain service to create transaction
   - Submits transaction to Cardano preprod network
   - Updates claim: `payout_status = 'completed'`, saves `tx_hash`

4. **User Views Transaction**
   - Frontend shows "✅ Completed" status
   - "View Transaction Details" button appears
   - Click to see transaction on CardanoScan explorer

**Important:** 
- ⚠️ If automation service is NOT running, claims stay in "Processing payout..." forever
- ✅ Automation service MUST be running in Terminal 3
- ⏱️ Max wait time: 60 seconds after clicking "Claim Amount"

---

## 🧪 Testing the Complete Flow

### Test Scenario: Genuine Claim → Blockchain Payout

**Step 1: Submit Claim**
1. Open http://localhost:5173
2. Fill in claim form:
   - Patient Name: `John Doe`
   - Age: `45`
   - Gender: `Male`
   - Diagnosis: `Diabetes`
   - Amount Billed: `100` (ADA)
3. Click "Submit Claim"

**Expected Result:**
```
✅ ML Prediction: genuine (Confidence: 85%)
Status: Approved
```

**Step 2: Trigger Payout**
1. Click "Claim Amount" button
2. Status changes to: `Waiting for payment...`

**Step 3: Wait for Automation (60 seconds)**
Watch the Go automation service terminal:

```bash
🔍 Checking for pending payouts...
   Found 1 pending payout(s)

💰 Processing Claim #1
   User: John Doe (john@example.com)
   Amount: ₳100.00
   Wallet: addr_test1qz...
   Hashed ID: blake2b_abc123...
   🔗 Calling blockchain service...
   📤 Sending 100000000 lovelace (100.00 ADA) to addr_test1qz...
   ✅ Transaction submitted to Cardano preprod network
   🔍 Explorer: https://preprod.cardanoscan.io/transaction/abc123...
   ✓ Claim #1 processed successfully

✅ Batch processing complete
```

**Step 4: Check Blockchain**
1. Frontend updates with transaction hash
2. Click the hash to open CardanoScan
3. Verify:
   - ✅ Transaction confirmed
   - ✅ Metadata label 674 contains claim details
   - ✅ Output shows 100 ADA sent to user wallet

---

## 📊 Database Verification

Check all tables after successful payout:

```bash
# 1. View claims table
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust \
  -c "SELECT id, user_id, amount_billed, ml_status, payout_status, tx_hash FROM claims;"

# 2. View blockchain transactions
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust \
  -c "SELECT tx_hash, claim_id, confirmations, status, block_height FROM blockchain_transactions;"

# 3. View combined view
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust \
  -c "SELECT * FROM claim_transactions LIMIT 5;"

# 4. View public payouts (privacy-preserved)
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust \
  -c "SELECT hashed_user_id, amount, tx_hash, created_at FROM public_payouts;"
```

---

## ✅ Service Status Checklist

Use these commands to verify all services are running:

```bash
# 1. ML Service
curl -s http://localhost:8000/health | jq
# ✅ Expected: {"status": "healthy", "model": "loaded"}

# 2. Blockchain Service  
curl -s http://localhost:3001/health | jq
# ✅ Expected: Shows treasury balance and network

# 3. Frontend
curl -s http://localhost:5173 | head -n 5
# ✅ Expected: HTML content

# 4. Database
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust \
  -c "SELECT COUNT(*) FROM users;"
# ✅ Expected: count | 3

# 5. Go Service (check logs)
# ✅ Expected: "Polling every 60 seconds for pending payouts..."
```

---

## 🛠️ Troubleshooting

### Issue: "ECONNREFUSED localhost:3001"
**Cause:** Blockchain service not running
**Fix:**
```bash
cd blockchain-service
npm run dev
```

### Issue: "Treasury wallet has insufficient funds"
**Cause:** Treasury needs test tADA
**Fix:**
```bash
# 1. Get test ADA from faucet
# Visit: https://docs.cardano.org/cardano-testnets/tools/faucet/
# Send to: addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78

# 2. Check balance
curl http://localhost:3001/api/balance
```

### Issue: "Blockfrost API error: Invalid project_id"
**Cause:** Wrong or missing API key
**Fix:**
```bash
# 1. Check .env file
cat blockchain-service/.env | grep BLOCKFROST

# 2. Get new key from https://blockfrost.io
# 3. Update .env file
```

### Issue: Database connection failed
**Cause:** PostgreSQL not running or wrong credentials
**Fix:**
```bash
# 1. Check PostgreSQL status
sudo systemctl status postgresql

# 2. Test connection
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust -c "SELECT 1;"

# 3. If fails, check .env DATABASE_URL
```

### Issue: ML Service model not found
**Cause:** Missing model file
**Fix:**
```bash
cd ml-service
ls -lh voting_classifier_model.pkl
# Should exist and be ~500KB

# If missing, retrain:
python model_exporter.py
```

---

## 📁 Project Structure

```
model_1/
├── ml-service/              # Python ML fraud detection
│   ├── app.py              # Flask API
│   ├── predict.py          # Inference logic
│   └── voting_classifier_model.pkl
│
├── blockchain-service/      # Node.js Cardano integration
│   ├── src/
│   │   └── app.ts          # MeshSDK + Blockfrost
│   ├── package.json
│   └── .env
│
├── automation-service/      # Go payout processor
│   ├── database.go         # DB queries
│   ├── blockchain.go       # Blockchain API calls
│   ├── crypto.go           # Hashing
│   └── go.mod
│
├── client/                  # Vue 3 UI (ACTIVE)
│   ├── src/
│   │   ├── App.vue
│   │   ├── components/
│   │   │   ├── NavBar.vue
│   │   │   ├── WalletSelector.vue
│   │   │   ├── ClaimForm.vue
│   │   │   ├── ClaimsList.vue
│   │   │   ├── RecentActivity.vue
│   │   │   └── TransactionDetailsModal.vue
│   │   ├── api.js
│   │   └── main.js
│   └── package.json
│
├── frontend/                # Old frontend (not used)
│   └── (legacy files)
│
├── database/
│   └── migrations/
│       ├── 001_initial.sql
│       ├── 002_users.sql
│       └── 003_blockchain_transactions.sql
│
└── .env                     # Root config
```

---

## 🎯 Success Indicators

After starting all services, you should see:

✅ **ML Service:** `Running on http://127.0.0.1:8000`  
✅ **Blockchain Service:** `🚀 Blockchain Service Started Successfully!`  
✅ **Go Service:** `Polling every 60 seconds for pending payouts...`  
✅ **Frontend:** `Local: http://localhost:5173`  
✅ **Database:** All migrations applied  
✅ **Treasury:** Balance > 0 ADA  

---

## 📚 API Endpoints Summary

### ML Service (Port 8000)
- `GET /health` - Health check
- `POST /predict` - Fraud detection

### Blockchain Service (Port 3001)
- `GET /health` - Service status + balance
- `GET /api/balance` - Treasury balance
- `POST /api/payout-transaction` - Submit payout
- `GET /api/transaction/:txHash` - Transaction details

### Frontend (Port 5173)
- `GET /` - Main UI
- Connects to ML + blockchain services

---

## 🔒 Security Notes

1. **Treasury Mnemonic:** Stored in `.env` (DO NOT commit to git)
2. **Database Passwords:** In `.env` (DO NOT share)
3. **Blockfrost API Key:** Free tier, Preprod testnet only
4. **User Privacy:** User IDs hashed with Blake2b in `public_payouts`

---

## 🚀 Next Steps

After everything is running:

1. ✅ Test genuine claim flow
2. ✅ Test fraudulent claim rejection
3. ✅ Verify transactions on CardanoScan
4. ✅ Check database records
5. 🎥 Record demo for presentation
6. 📊 Create architecture diagram
7. 📝 Document findings for FYP report

---

**Need help?** Check the TROUBLESHOOTING section above or review individual service logs.

**Working?** 🎉 Your complete blockchain-integrated insurance dApp is live!
