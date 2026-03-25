# HealthTrust

**AI-Driven Healthcare Insurance Fraud Detection on Cardano Blockchain**

[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)
[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](#-ml-model)
[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

> 🌐 **Live Demo:** [http://178.128.212.100](http://178.128.212.100) (Cardano Preprod Testnet)

---

## 🎯 What Is HealthTrust?

HealthTrust is a **blockchain application (bApp)** combining:
- **AI fraud detection** using Gradient Boosting (86.3% accuracy)
- **GPT-4o Vision** document verification
- **Automated Cardano payouts** on Preprod Testnet
- **On-chain records** with CIP-20 metadata for transparency

It's a **hybrid architecture** — AI/ML runs on centralized services while Cardano serves as a **settlement and audit layer**. Every payout is recorded on-chain with metadata.

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🤖 **AI Fraud Detection** | Gradient Boosting classifier with SMOTE — **86.3% accuracy** |
| 🖼️ **Image Verification** | GPT-4o Vision compares prescription vs pharmacy receipt |
| ⛓️ **Blockchain Payouts** | Automated real ADA transactions via MeshSDK |
| 📋 **On-Chain Records** | Every payout recorded with CIP-20 metadata (label 674) |
| 🔒 **Privacy Preserved** | Blake2b-256 hashing for user IDs — no PII on ledger |
| ⚡ **60-Second Automation** | Go service polls and processes approved claims continuously |
| 📜 **Smart Contract** | Plutus V3 Insurance Gatekeeper validator (compiled & deployed) |
| 📊 **Dashboard** | Interactive stat cards, claim history, real-time tracking |

---

## 🏗️ Architecture

```
┌────────────────────────────────────────────────────────────┐
│                     Nginx (port 80)                        │
│   /  → Vue SPA     /api/ → Python :8000                   │
│                     /service/ → Node.js :3001              │
└──────┬──────────────────┬──────────────────┬───────────────┘
       │                  │                  │
┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼───────────────┐
│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK   │
│  TailwindCSS│   │  ML Service │   │  Blockchain Service  │
│  MeshSDK    │   │  Port 8000  │   │  Port 3001           │
└─────────────┘   └──────┬──────┘   └──────┬───────────────┘
                         │                 │
                  ┌──────▼─────────────────▼────┐
                  │     PostgreSQL (5432)        │
                  │     Database: HealthTrust    │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │   Go Automation Service      │
                  │   Polls DB → triggers payouts│
                  │   every 60 seconds           │
                  └──────────────────────────────┘
```

| Service | Language | Framework | Port |
|---------|----------|-----------|------|
| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | 80 (Nginx) |
| ML Service | Python 3.12 | FastAPI + Uvicorn | 8000 |
| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 |
| Automation | Go 1.22 | stdlib + lib/pq | Background |
| Smart Contract | Aiken 1.1.19 | Plutus V3 | On-chain |
| Database | SQL | PostgreSQL 16 | 5432 |

---

## 🧠 ML Model

| Property | Value |
|----------|-------|
| **Algorithm** | Gradient Boosting Classifier |
| **Accuracy** | 86.3% |
| **F1 Score** | 0.80 |
| **Dataset** | 20,000 simulated healthcare claims |
| **Features** | Age, gender, diagnosis, stay duration, amount billed, num procedures |
| **Balancing** | SMOTE (Synthetic Minority Oversampling) |
| **Confidence Threshold** | 90% (low-confidence genuine → rejected) |
| **Training Notebook** | `healthcare_fraud_final.ipynb` |

---

## 📜 Smart Contract (Aiken Plutus V3)

```aiken
validator insurance_gatekeeper {
  spend(datum, _redeemer, _own_ref, ctx) {
    // 1. Transaction MUST be signed by treasury wallet
    list.has(ctx.extra_signatories, treasury_pkh)
    // 2. Datum must contain non-empty hashed_user_id
      && datum.hashed_user_id != ""
  }
}
```

| Property | Value |
|----------|-------|
| **Script Hash** | `5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e` |
| **Script Address** | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |
| **Language** | Plutus V3 (Conway era) |
| **Status** | Compiled, deployed, and monitored on Preprod |

> **Note:** Script spending is disabled due to MeshSDK v1 limitation with Plutus V3 CBOR serialization. Payouts use treasury wallet directly (same key, equivalent security). Upgrade planned with Lucid Evolution once available.

---

## 🔒 Privacy: On-Chain Data

Every payout includes **CIP-20 metadata** (label 674). After privacy audit:

| Field | On-Chain? | Notes |
|-------|-----------|-------|
| `claim_id` | ✅ | Claim reference number |
| `amount_usd` | ✅ | Stored as string |
| `amount_ada` | ✅ | Stored as string |
| `ml_status` | ✅ | AI prediction result |
| `claim_type` | ✅ | Diagnosis category |
| `hashed_user_id` | ✅ | Blake2b-256 hash (not reversible) |
| `smart_contract` | ✅ | Script address reference |
| `patient_name` | ❌ | Removed — no PII on permanent ledger |
| `user_id` | ❌ | Removed — linkable integer IDs |

**User hashing:** Deterministic Blake2b-256 of (name + email) in Go automation service. Same user always produces same hash, but hash cannot be reversed.

---

## 🎮 How to Use the App

### Step 1 — Install a Wallet

Install one of these browser extensions and **switch to Preprod Testnet**:

| Wallet | Link |
|--------|------|
| **Nami** | [namiwallet.io](https://namiwallet.io) |
| **Eternl** | [eternl.io](https://eternl.io) |
| **Lace** | [lace.io](https://lace.io) |

> ⚠️ You **must** use **Cardano Preprod Testnet**, not Mainnet.

### Step 2 — Connect a Test Wallet (or Your Own)

Three pre-loaded test wallets are available to import:

| User | 24-Word Mnemonic |
|------|-----------------|
| **Alice Johnson** | `wolf call ramp month fashion wise bike sting cry oven stairs book flee access route gown donkey crunch quantum result comfort warm return elevator` |
| **Bob Smith** | `gown notice anxiety dilemma casual such dismiss inner puzzle sun surround aim digital company work ridge disagree undo diesel cradle come chief damp make` |
| **Carol Williams** | `humble same cricket improve donate exercise game carry genuine life game book critic stock focus field oblige volcano east neither electric pulp collect tattoo` |

**To import:** Open wallet extension → Import/Restore → Paste mnemonic → Set password → Switch to Preprod

> 💡 **Don't want to import?** You can connect **your own wallet** — the app auto-registers new users.

### Step 3 — Submit a Claim

1. Open [http://178.128.212.100](http://178.128.212.100) → **Connect Wallet** → **Set up profile**
2. Click **"Submit New Claim"**
3. Fill in hospital stay details:
   - Admission Date & Discharge Date
   - Primary Diagnosis (Pregnancy, Hypertension, Diabetes, Pneumonia, etc.)
   - Total Amount Billed (in ADA)
4. Optionally upload **prescription + receipt** images for GPT-4o verification
5. Click **Submit** → AI results shown instantly

### Step 4 — Get Your Payout

If **approved**:
1. Open **Claims History** (or click the **"Pending Payout"** stat card)
2. Find your approved claim
3. Click **"Claim Amount"**
4. Wait 60 seconds — Go automation service picks it up
5. Real **ADA** is sent from treasury wallet to your connected wallet
6. Transaction hash appears — click to verify on [CardanoScan (Preprod)](https://preprod.cardanoscan.io)

---

## 📁 Project Structure

```
HealthTrust/
├── client/                      # Vue 3 Frontend (SPA)
│   ├── src/
│   │   ├── components/          # ClaimForm, ClaimsList, NavBar, WalletSelector, etc.
│   │   ├── composables/         # useToast
│   │   ├── api.js               # API client
│   │   ├── App.vue              # Root component (dashboard, modals, profile)
│   │   └── main.js              # Entry point
│   ├── tailwind.config.js
│   └── vite.config.js
│
├── ml-service/                  # Python ML Service
│   ├── main.py                  # FastAPI app setup
│   ├── routes.py                # All API endpoints
│   ├── model_loader.py          # ML model loading + prediction
│   ├── database.py              # SQLAlchemy ORM models
│   ├── prescription_verifier.py # GPT-4o Vision image verification
│   ├── export_model.py          # Train & export ML model
│   ├── requirements.txt
│   └── models/                  # Trained model artifacts (.pkl)
│
├── server/blockchain-service/   # Node.js Blockchain Service
│   └── src/app.ts               # Express + MeshSDK + Blockfrost
│
├── automation-service/          # Go Automation Service
│   ├── database.go              # DB polling (60s) + orchestration
│   ├── blockchain.go            # HTTP client → blockchain service
│   └── crypto.go                # Blake2b-256 hashing
│
├── aiken-contracts/             # Aiken Smart Contract (Plutus V3)
│   ├── validators/
│   │   └── insurance_gatekeeper.ak
│   ├── aiken.toml
│   └── build/                   # Compiled Plutus script
│
├── database/                    # PostgreSQL Schema
│   ├── schema.sql               # Core tables
│   ├── seed.sql                 # Test users (alice, bob, carol)
│   └── migrations/              # Schema updates (003–005)
│
├── treasury-wallet/             # Cardano wallet generation scripts
├── healthcare_fraud_final.ipynb # ML training notebook
├── start-all-services.sh        # Start all local services
└── README.md
```

---

## 🔗 API Reference

### ML Service (`/api/` — Port 8000)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Health check + model info |
| `POST` | `/predict` | Submit claim → ML fraud prediction |
| `GET` | `/users/{wallet}` | Get user + claims (auto-registers new wallets) |
| `PUT` | `/users/{wallet}/profile` | Update user profile |
| `PUT` | `/claims/{id}/trigger-payout` | Trigger blockchain payout |
| `POST` | `/verify-images` | Prescription vs receipt verification (GPT-4o) |
| `GET` | `/ada-price` | Live ADA/USD price from CoinMarketCap |
| `GET` | `/model/info` | ML model metadata + feature importance |
| `GET` | `/recent-activity` | Recent claims for landing page |

### Blockchain Service (`/service/` — Port 3001)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/health` | Treasury + smart contract balance |
| `POST` | `/api/payout-transaction` | Build, sign, submit ADA transaction |
| `GET` | `/api/transaction/{txHash}` | Full transaction details from Blockfrost |
| `GET` | `/api/balance` | Treasury + smart contract balance |
| `GET` | `/api/epoch` | Current epoch, slot, block height |

---

## 🚀 Quick Start

### Prerequisites

- **Node.js** ≥ 18
- **Python** ≥ 3.10
- **Go** ≥ 1.21
- **PostgreSQL** ≥ 14
- **Nginx** (for production)
- **Blockfrost API key** — free at [blockfrost.io](https://blockfrost.io) (select Preprod)
- **OpenAI API key** — for GPT-4o image verification
- **CoinMarketCap API key** — for USD/ADA price conversion

### 1. Clone the Repository

```bash
git clone https://github.com/Yadurshan-R/HealthTrust.git
cd HealthTrust
```

### 2. Set Up the Database

```bash
sudo -u postgres psql -c "CREATE USER healthtrust WITH PASSWORD 'your_password';"
sudo -u postgres psql -c "CREATE DATABASE \"HealthTrust\" OWNER healthtrust;"
sudo -u postgres psql -d HealthTrust -f database/schema.sql
sudo -u postgres psql -d HealthTrust -f database/seed.sql
sudo -u postgres psql -d HealthTrust -f database/migrations/003_blockchain_transactions.sql
sudo -u postgres psql -d HealthTrust -f database/migrations/004_add_payout_date.sql
sudo -u postgres psql -d HealthTrust -f database/migrations/005_add_image_verification.sql
```

### 3. Set Up Environment Variables

**`ml-service/.env`**
```env
DATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust
OPENAI_API_KEY=sk-your-openai-api-key
CMC_API_KEY=your-coinmarketcap-api-key
```

**`server/blockchain-service/.env`**
```env
BLOCKFROST_API_KEY=preprodYOUR_BLOCKFROST_KEY
TREASURY_MNEMONIC=your 24 word treasury wallet mnemonic here
TREASURY_ADDRESS=addr_test1your_treasury_address
PORT=3001
CARDANO_NETWORK=preprod
```

**`automation-service/.env`**
```env
DATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust
```

> 💡 **Treasury Wallet:** Generate with `cd treasury-wallet && npm install && node generate-wallet.js`. Fund from [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/).

### 4. Install Dependencies & Start Services

```bash
# ML Service (Python)
cd ml-service
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python export_model.py                    # First run: train & export model
uvicorn main:app --host 127.0.0.1 --port 8000

# Blockchain Service (Node.js)
cd server/blockchain-service
npm install
npx ts-node src/app.ts

# Automation (Go)
cd automation-service
go mod tidy
go run database.go blockchain.go crypto.go

# Frontend (Vue 3)
cd client
npm install
npm run build     # Production build → client/dist/
```

### 5. Nginx Configuration (Production)

```nginx
server {
    listen 80;
    server_name your_domain_or_ip;

    location / {
        root /path/to/HealthTrust/client/dist;
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:8000/;
    }

    location /service/ {
        proxy_pass http://127.0.0.1:3001/;
    }
}
```

---

## 🔐 Security

- **Secrets** — Wallet mnemonics, API keys, DB passwords in `.env` files (gitignored)
- **Backend isolation** — ML (8000) and Blockchain (3001) bound to `127.0.0.1` only
- **Nginx** — Only public-facing process (port 80)
- **Firewall** — UFW allows only ports 22, 80, 443
- **Privacy** — Blake2b-256 hashed user IDs on blockchain — no PII on-chain
- **Smart contract** — Treasury signature required for every payout

---

## 🌐 Deployment

Deployed on **DigitalOcean** at [http://178.128.212.100](http://178.128.212.100)

| Component | Details |
|-----------|---------|
| Server | DigitalOcean Droplet — Ubuntu 22.04, 2GB RAM |
| Services | 3 systemd units (`healthtrust-ml`, `healthtrust-blockchain`, `healthtrust-automation`) |
| Database | PostgreSQL 16 |
| Network | Cardano Preprod Testnet |

```bash
# Deploy new changes
bash deploy.sh   # Builds frontend → syncs to server → restarts services

# Check service status
sudo systemctl status healthtrust-ml healthtrust-blockchain healthtrust-automation

# View logs
sudo journalctl -u healthtrust-ml -f
```

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🔗 Resources

- [Cardano Documentation](https://docs.cardano.org)
- [MeshSDK](https://meshjs.dev)
- [Blockfrost API](https://blockfrost.io)
- [Aiken Smart Contracts](https://aiken-lang.org)
- [Lucid Evolution](https://github.com/Anastasia-Labs/lucid-evolution) — recommended for Plutus V3 script spending
- [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/)
- [CardanoScan (Preprod)](https://preprod.cardanoscan.io)

---

*Built by [Yadurshan R](https://github.com/Yadurshan-R) — Final Year Project 2025/2026*
