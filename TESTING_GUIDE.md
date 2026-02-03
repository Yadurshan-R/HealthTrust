# 🧪 Step-by-Step Testing Guide

## Complete System Test - Healthcare Insurance dApp

Follow these steps **in order** to verify everything works.

---

## 📋 Prerequisites Check

### ✅ Step 0: Verify Prerequisites

```bash
# 1. Check Node.js
node --version
# Expected: v18.x or higher

# 2. Check Python
python3 --version
# Expected: 3.8 or higher

# 3. Check PostgreSQL
psql --version
# Expected: 14.x or higher

# 4. Check Go
go version
# Expected: 1.20 or higher
```

**All good?** → Continue to Step 1

---

## 🗄️ STEP 1: Test Database Connection

```bash
# Test database connection
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust -c "SELECT COUNT(*) FROM users;"
```

**Expected Output:**
```
 count 
-------
     3
(1 row)
```

**✅ Success:** Database is working  
**❌ Failed:** Run `./setup-database.sh` first

---

## 🔗 STEP 2: Start Blockchain Service

**Open Terminal 1:**

```bash
cd /home/yadu/Development/My_FYP/model_1/server/blockchain-service

# Start the service
npm run dev
```

**Expected Output:**
```
🔧 Initializing Blockchain Service...
   Network: preprod
   Treasury: addr_test1qzdegcxyjs8ujtgphe...
✅ Treasury wallet initialized

============================================================
🚀 Blockchain Service Started Successfully!
============================================================
📡 Server: http://localhost:3001
🌐 Network: PREPROD
💰 Treasury: addr_test1qzdeg...
============================================================

Endpoints:
  GET  /health                        - Service health check
  GET  /api/balance                   - Treasury balance
  POST /api/payout-transaction        - Submit payout
  GET  /api/transaction/:txHash       - Get transaction details
============================================================
```

**✅ Look for:** "Treasury wallet initialized" ✅  
**⏸️ Leave this terminal running!**

---

## 🏥 STEP 3: Test Blockchain Service Health

**Open Terminal 2 (new terminal):**

```bash
# Test health endpoint
curl http://localhost:3001/health
```

**Expected Output:**
```json
{
  "status": "healthy",
  "network": "preprod",
  "treasuryAddress": "addr_test1qzdegcxyjs8ujtgphe...",
  "balanceADA": "1000.00",
  "balanceLovelace": 1000000000,
  "utxoCount": 5
}
```

**✅ Success:** Blockchain service is connected to treasury!  
**❌ Error:** Check Terminal 1 for errors

---

## 💰 STEP 4: Check Treasury Balance

```bash
# Get detailed balance
curl http://localhost:3001/api/balance
```

**Expected Output:**
```json
{
  "address": "addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78",
  "balanceADA": "1000.00",
  "balanceLovelace": 1000000000,
  "utxoCount": 5
}
```

**Check:**
- ✅ `balanceADA` > 0 → Treasury has funds
- ❌ `balanceADA` = "0.00" → Need to fund treasury (see Step 4b)

---

### 💸 STEP 4b: Fund Treasury (If Balance is 0)

**If treasury balance is 0, fund it:**

1. **Copy your treasury address:**
   ```bash
   cat passwords.md | grep "addr_test1qzdeg"
   ```

2. **Visit Cardano Faucet:**
   - URL: https://docs.cardano.org/cardano-testnets/tools/faucet/
   - Paste your treasury address
   - Request 10,000 tADA
   - Wait 2-3 minutes

3. **Verify funds arrived:**
   ```bash
   curl http://localhost:3001/api/balance
   ```

**Continue once balance > 0** ✅

---

## 🤖 STEP 5: Start ML Service

**Open Terminal 3:**

```bash
cd /home/yadu/Development/My_FYP/model_1/ml-service

# Activate virtual environment
source venv/bin/activate

# Start ML service
python app.py
```

**Expected Output:**
```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://127.0.0.1:8000
```

**⏸️ Leave this terminal running!**

---

## 🧪 STEP 6: Test ML Service

**Back to Terminal 2:**

```bash
# Test ML health
curl http://localhost:8000/health
```

**Expected Output:**
```json
{
  "status": "healthy",
  "model": "loaded"
}
```

**✅ Success:** ML service is ready!

---

## 🔄 STEP 7: Start Go Automation Service

**Open Terminal 4:**

```bash
cd /home/yadu/Development/My_FYP/model_1/automation-service

# Start automation service
go run *.go
```

**Expected Output:**
```
✓ Database connected
🚀 Cardano Insurance Automation Service Started
📡 Polling every 60 seconds for pending payouts...

🔍 Checking for pending payouts...
   No pending payouts found
```

**⏸️ Leave this terminal running!**

---

## 🎨 STEP 8: Start Frontend

**Open Terminal 5:**

```bash
cd /home/yadu/Development/My_FYP/model_1/client

# Start frontend
npm run dev
```

**Expected Output:**
```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

**⏸️ Leave this terminal running!**

---

## 🌐 STEP 9: Open Frontend

**Open your browser:**
```
http://localhost:5173
```

**You should see:** Healthcare Insurance claim form

---

## 🧪 STEP 10: Submit Test Claim (Genuine)

**Fill in the form:**

```
Patient Name: John Doe
Age: 45
Gender: Male
Diagnosis: Diabetes
Amount Billed: 100
```

**Click "Submit Claim"**

**Expected Result:**
- ✅ ML Prediction appears: "genuine" (green)
- ✅ Confidence score: ~85%
- ✅ Status: "Approved"
- ✅ "Claim Amount" button appears

---

## 💸 STEP 11: Trigger Payout

**In the frontend:**
1. Click **"Claim Amount"** button
2. Status changes to "Waiting for payment..."

**Watch Terminal 4 (Go service):**

After ~60 seconds, you should see:
```
🔍 Checking for pending payouts...
   Found 1 pending payout(s)

💰 Processing Claim #1
   User: John Doe (alice@example.com)
   Amount: ₳100.00
   Wallet: addr_test1qz...
   Hashed ID: blake2b_...
   🔗 Calling blockchain service...
   📤 Sending 100000000 lovelace (100.00 ADA)
   ✅ Transaction submitted to Cardano preprod network
   🔍 Explorer: https://preprod.cardanoscan.io/transaction/abc123...
   ✓ Claim #1 processed successfully

✅ Batch processing complete
```

**Watch Terminal 1 (Blockchain service):**
```
📤 Processing payout transaction...
   Recipient: addr_test1qz...
   Amount: 100000000 lovelace (100.00 ADA)
   Claim ID: 1
   Building transaction...
   Signing transaction...
   Submitting to Cardano network...
✅ Transaction submitted successfully!
   TX Hash: abc123def456...
   Explorer: https://preprod.cardanoscan.io/transaction/abc123...
```

---

## 🔍 STEP 12: Verify on Blockchain

**In the frontend:**
- Transaction hash appears
- Click the hash

**Opens CardanoScan:**
- Transaction details visible
- Status: Pending → Confirmed
- Metadata label 674 contains claim data

---

## ✅ STEP 13: Verify Database

**Back to Terminal 2:**

```bash
# Check claim status
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust -c "SELECT id, amount_billed, ml_status, payout_status, LEFT(tx_hash, 20) as tx FROM claims;"
```

**Expected Output:**
```
 id | amount_billed | ml_status | payout_status |         tx          
----+---------------+-----------+---------------+---------------------
  1 |        100.00 | genuine   | completed     | abc123def456789...
```

**Check blockchain transactions:**
```bash
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust -c "SELECT LEFT(tx_hash, 20) as tx, confirmations, status FROM blockchain_transactions;"
```

**Expected Output:**
```
         tx          | confirmations | status   
---------------------+---------------+----------
 abc123def456789... |             5 | confirmed
```

---

## 🎉 SUCCESS INDICATORS

If you see all of these, **everything works!** ✅

| Component | Success Indicator |
|-----------|-------------------|
| **Database** | 3 users returned |
| **Blockchain Service** | Treasury balance > 0 |
| **ML Service** | Health check returns "healthy" |
| **Go Service** | "Polling every 60 seconds" |
| **Frontend** | Form loads at localhost:5173 |
| **Claim Processing** | ML predicts "genuine" |
| **Payout** | GO service logs "Transaction submitted" |
| **Blockchain** | TX hash appears in CardanoScan |
| **Database Update** | claim payout_status = "completed" |

---

## 🧪 BONUS: Test Fraudulent Claim

**Submit another claim with suspicious data:**

```
Patient Name: Fraud Test
Age: 150           ← Unrealistic
Gender: Male
Diagnosis: Common Cold
Amount Billed: 999999  ← Excessive
```

**Expected Result:**
- ❌ ML Prediction: "fake" (red)
- ❌ Status: "Rejected"
- ❌ No "Claim Amount" button
- ❌ No payout triggered

---

## 📊 Summary Commands

**Check all services at once:**

```bash
# Terminal Window 1
curl -s http://localhost:8000/health | jq .status      # ML
curl -s http://localhost:3001/health | jq .status      # Blockchain
curl -s http://localhost:5173 | head -n 1              # Frontend

# All should return success
```

---

## 🛑 How to Stop All Services

**Press Ctrl+C in each terminal:**
- Terminal 1: Blockchain service
- Terminal 2: Can close
- Terminal 3: ML service
- Terminal 4: Go service
- Terminal 5: Frontend

**Or kill by port:**
```bash
lsof -ti:8000,3001,5173 | xargs kill -9
pkill -f "go run"
```

---

## 🎯 What We Tested

✅ **Database Connection** - PostgreSQL working  
✅ **Treasury Wallet** - Connected via MeshSDK  
✅ **Blockchain Service** - API endpoints working  
✅ **ML Service** - Fraud detection functional  
✅ **Go Automation** - Polling and processing  
✅ **Frontend** - User interface loading  
✅ **End-to-End Flow** - Claim → ML → Payout → Blockchain  
✅ **Database Updates** - Records stored correctly  
✅ **On-Chain Verification** - Transactions on CardanoScan  

---

**🎉 If all steps pass, your Healthcare Insurance dApp is fully functional!**
