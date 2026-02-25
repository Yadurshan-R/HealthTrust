# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 Healthcare Insurance Fraud Detection dApp



**Final Year Project** — Decentralized Healthcare Insurance Claims Processing



[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)**Final Year Project** — Decentralized Healthcare Insurance Claims Processing

[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)

[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)

[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)**Final Year Project** — Decentralized Healthcare Insurance Claims Processing

> 🌐 **Live Demo:** [http://178.128.212.100](http://178.128.212.100) (Cardano Preprod Testnet)

[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)

---

[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)

## 🎯 What Is HealthTrust?

[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

HealthTrust is a decentralized health insurance application built on the **Cardano blockchain**. It combines **AI fraud detection**, **GPT-4o Vision document verification**, and **automated blockchain payouts** to process insurance claims transparently and immutably.

[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)**Final Year Project** — Decentralized Healthcare Insurance Claims Processing

### How It Works

> 🌐 **Live App:** [http://178.128.212.100](http://178.128.212.100)

1. Connect your **Lace** wallet (Cardano Preprod Testnet)

2. Set up your profile (name, age, gender)[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)

3. Submit an insurance claim with hospital stay details

4. AI model predicts genuine vs fraudulent (**86.3% accuracy**)---

5. Optionally upload prescription + receipt → **GPT-4o Vision** verifies them

6. If approved → click **"Claim Amount"** to trigger payout[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)

7. Within 60 seconds, real **tADA** is sent to your wallet

8. Transaction is permanently recorded on Cardano with **CIP-20 metadata**## 🎯 What Is HealthTrust?



---[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)



## ✨ Key FeaturesHealthTrust is a decentralized health insurance application built on the **Cardano blockchain**. It combines **AI fraud detection**, **GPT-4o Vision document verification**, and **automated blockchain payouts** to process insurance claims transparently and immutably.



| Feature | Description |[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)**Final Year Project** — Decentralized Healthcare Insurance Claims Processing

|---------|-------------|

| 🤖 **AI Fraud Detection** | Gradient Boosting classifier with SMOTE oversampling — **86.3% accuracy** |### How It Works

| 🖼️ **Image Verification** | GPT-4o Vision compares prescription against pharmacy receipt |

| ⛓️ **Blockchain Payouts** | Automated real ADA transactions on Cardano Preprod via MeshSDK |> 🌐 **Live App:** [http://178.128.212.100](http://178.128.212.100)

| 💱 **USD → ADA Conversion** | Live CoinMarketCap price conversion shown before payout |

| 📋 **On-Chain Records** | Every payout recorded with CIP-20 metadata (label 674) |```

| 🔒 **Privacy Preserved** | Blake2b-256 hashed user IDs on-chain — no PII on public ledger |

| ⚡ **60-Second Automation** | Go service polls and processes approved payouts continuously |1. Connect your Cardano wallet (Nami, Eternl, or Lace)[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)

| 📜 **Aiken Smart Contract** | Plutus V3 Insurance Gatekeeper validator compiled & deployed |

| 📊 **Interactive Dashboard** | Clickable stat cards, claim history, real-time status tracking |2. Submit an insurance claim with hospital stay details



---3. AI model predicts genuine vs fraudulent (86.3% accuracy)---



## 🏗️ Architecture4. Optionally upload prescription + receipt → GPT-4o Vision verifies them



```5. If approved → click "Claim Amount" to trigger payout[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)

┌────────────────────────────────────────────────────────────┐

│                     Nginx (port 80)                        │6. Within 60 seconds, real ADA is sent to your wallet

│   /  → Vue SPA     /api/ → Python :8000                   │

│                     /service/ → Node.js :3001              │7. Transaction is permanently recorded on Cardano with CIP-20 metadata## 🎯 What Is HealthTrust?

└──────┬──────────────────┬──────────────────┬───────────────┘

       │                  │                  │```

┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼───────────────┐

│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK   │[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

│  TailwindCSS│   │  ML Service │   │  Blockchain Service  │

│  MeshSDK    │   │  Port 8000  │   │  Port 3001           │---

└─────────────┘   └──────┬──────┘   └──────┬───────────────┘

                         │                 │HealthTrust is a decentralized health insurance application built on the **Cardano blockchain**. It combines **AI fraud detection**, **GPT-4o Vision document verification**, and **automated blockchain payouts** to process insurance claims transparently and immutably.

                  ┌──────▼─────────────────▼────┐

                  │     PostgreSQL (5432)        │## ✨ Key Features

                  │     Database: HealthTrust    │

                  └──────────────┬───────────────┘[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)**AI-Powered Insurance Claims Processing on Cardano Blockchain**

                                 │

                  ┌──────────────▼───────────────┐| Feature | Description |

                  │   Go Automation Service      │

                  │   Polls DB → triggers payouts│|---------|-------------|### How It Works

                  │   every 60 seconds           │

                  └──────────────────────────────┘| 🤖 **AI Fraud Detection** | Gradient Boosting classifier with SMOTE oversampling — **86.3% accuracy** |

```

| 🖼️ **Image Verification** | GPT-4o Vision compares prescription against pharmacy receipt |> 🌐 **Live App:** [http://178.128.212.100](http://178.128.212.100)

| Service | Language | Framework | Port |

|---------|----------|-----------|------|| ⛓️ **Blockchain Payouts** | Automated real ADA transactions on Cardano Preprod via MeshSDK |

| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | 80 (Nginx) |

| ML Service | Python 3.12 | FastAPI + Uvicorn | 8000 || 📋 **On-Chain Records** | Every payout recorded with CIP-20 metadata (label 674) |```

| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 |

| Automation | Go 1.22 | stdlib + lib/pq | Background || 🔒 **Privacy Preserved** | Blake2b-256 hashing for user identity on public ledger |

| Smart Contract | Aiken 1.1.19 | Plutus V3 | On-chain |

| Database | SQL | PostgreSQL 16 | 5432 || ⚡ **60-Second Automation** | Go service polls and processes approved payouts continuously |1. Connect your Cardano wallet (Nami, Eternl, or Lace)[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)



---| 📜 **Aiken Smart Contract** | Plutus V3 Insurance Gatekeeper validator compiled & deployed |



## 🧠 ML Model| 📊 **Interactive Dashboard** | Clickable stats, claim history, real-time status tracking |2. Submit an insurance claim with hospital stay details



| Property | Value |

|----------|-------|

| Algorithm | Gradient Boosting Classifier |---3. AI model predicts genuine vs fraudulent (86.3% accuracy)---

| Accuracy | **86.3%** |

| F1 Score | **0.80** |

| Dataset | 20,000 simulated healthcare claims |

| Features | Age, gender, diagnosis, stay duration, amount billed, num procedures |## 🏗️ Architecture4. Optionally upload prescription + receipt → GPT-4o Vision verifies them

| Balancing | SMOTE (Synthetic Minority Oversampling) |

| Confidence Threshold | 90% (low-confidence genuine → rejected) |

| Training Notebook | `healthcare_fraud_final.ipynb` |

| Export Script | `ml-service/export_model.py` |```5. If approved → click "Claim Amount" to trigger payout[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)[![ML Model](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)



### Training Pipeline┌────────────────────────────────────────────────────────────┐



The model was trained in `healthcare_fraud_final.ipynb` using the following pipeline:│                     Nginx (port 80)                        │6. Within 60 seconds, real ADA is sent to your wallet



1. Load 20,000 simulated healthcare claims│   /  → Vue SPA     /api/ → Python :8000                   │

2. Feature engineering (binary fraud target, stay duration from dates)

3. 75/25 train/test split with one-hot encoding + StandardScaler│                     /service/ → Node.js :3001              │7. Transaction is permanently recorded on Cardano with CIP-20 metadata## 🎯 What Is HealthTrust?

4. SMOTE oversampling to balance fraud vs genuine classes

5. Train 7 models (Logistic, SVC, KNN, Decision Tree, Random Forest, Gradient Boosting, Voting Ensemble)└──────┬──────────────────┬──────────────────┬───────────────┘

6. Select best model by F1 score → **Gradient Boosting wins** at 86.3%

7. Export to `ml-service/models/` as pickle files       │                  │                  │```



---┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼───────────────┐



## 📜 Aiken Smart Contract│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK   │[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)



The **Insurance Gatekeeper** is a Plutus V3 validator written in Aiken:│  TailwindCSS│   │  ML Service │   │  Blockchain Service  │



```aiken│  MeshSDK    │   │  Port 8000  │   │  Port 3001           │---

validator insurance_gatekeeper {

  spend(datum, _redeemer, _own_ref, ctx) {└─────────────┘   └──────┬──────┘   └──────┬───────────────┘

    // 1. Transaction MUST be signed by treasury wallet

    list.has(ctx.extra_signatories, treasury_pkh)                         │                 │HealthTrust is a decentralized health insurance application built on the **Cardano blockchain**. It allows anyone with a Cardano wallet to submit insurance claims, get them verified by an AI model, and receive automated payouts in real ADA — all transparently recorded on-chain.

    // 2. Datum must contain non-empty hashed_user_id

      && datum.hashed_user_id != ""                  ┌──────▼─────────────────▼────┐

  }

}                  │     PostgreSQL (5432)        │## ✨ Key Features

```

                  │     Database: HealthTrust    │

| Property | Value |

|----------|-------|                  └──────────────┬───────────────┘[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)[![Cardano](https://img.shields.io/badge/Cardano-Preprod-blue)](https://preprod.cardanoscan.io)

| **Script Hash** | `5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e` |

| **Script Address** | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |                                 │

| **Language** | Plutus V3 (Conway era) |

| **Status** | Compiled, deployed, and monitored on Preprod |                  ┌──────────────▼───────────────┐| Feature | Description |



### Smart Contract Status                  │   Go Automation Service      │



The contract is **compiled and deployed** on Cardano Preprod. Its address is embedded in every payout transaction's metadata and monitored via the `/health` and `/api/balance` endpoints.                  │   Polls DB → triggers payouts│|---------|-------------|### How It Works



**Script spending is currently disabled** due to a known [MeshSDK v1 limitation](https://github.com/MeshJS/mesh/issues) with Plutus V3 CBOR serialization (`MalformedScriptWitnesses` error). This is a documented SDK bug — not a contract issue. Payouts are processed via the treasury wallet directly, which requires the same private key.                  │   every 60 seconds           │



**Migration path:** Lucid Evolution (by Anastasia Labs) has full Plutus V3 support and is identified as the recommended upgrade path to enable on-chain script spending.                  └──────────────────────────────┘| 🤖 **AI Fraud Detection** | Gradient Boosting classifier trained on 20,000+ claims — **86.3% accuracy** |



---```



## 🔒 Privacy: On-Chain Data| 🖼️ **Image Verification** | GPT-4o Vision compares prescription against pharmacy receipt |---



Every payout transaction includes **CIP-20 metadata** (label 674). After a privacy audit, the following data is stored on-chain:| Service | Language | Framework | Port |



| Field | On-Chain? | Notes ||---------|----------|-----------|------|| ⛓️ **Blockchain Payouts** | Automated real ADA transactions on Cardano Preprod via MeshSDK |

|-------|-----------|-------|

| `claim_id` | ✅ | Claim reference number || Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | 80 (Nginx) |

| `amount_usd` | ✅ | Stored as string (Cardano metadata doesn't support floats) |

| `amount_ada` | ✅ | Stored as string || ML Service | Python 3.12 | FastAPI + Uvicorn | 8000 || 📋 **On-Chain Records** | Every payout recorded with CIP-20 metadata (label 674) |```

| `ml_status` | ✅ | AI prediction result |

| `claim_type` | ✅ | Diagnosis category || Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 |

| `hashed_user_id` | ✅ | Blake2b-256 hash of (name + email) — **not reversible** |

| `smart_contract` | ✅ | Script address reference || Automation | Go 1.22 | stdlib + lib/pq | Background || 🔒 **Privacy Preserved** | Blake2b-256 hashing for user identity on public ledger |

| `patient_name` | ❌ | **Removed** — PII should not be on a permanent public ledger |

| `user_id` | ❌ | **Removed** — integer IDs are linkable || Smart Contract | Aiken | Plutus V3 | On-chain |



Each user gets a **unique, deterministic hash** via Blake2b-256 in the Go automation service (`crypto.go`). The same user always produces the same hash, but the name/email cannot be recovered from it.| Database | SQL | PostgreSQL 16 | 5432 || ⚡ **60-Second Automation** | Go service polls and processes approved payouts continuously |1. Connect your Cardano wallet (Nami, Eternl, or Lace)[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)[![ML Model](https://img.shields.io/badge/ML%20Accuracy-86.3%25-green)](ml-service/)



---



## 🎮 How to Use the App---| 📜 **Aiken Smart Contract** | Plutus V3 Insurance Gatekeeper validator compiled & deployed |



### Step 1 — Install a Wallet



Install the **Lace** wallet browser extension from [lace.io](https://www.lace.io/) and **switch to Preprod Testnet**.## 🧠 ML Model| 📊 **Interactive Dashboard** | Clickable stats, claim history, real-time status tracking |2. Set up your profile (name, age, gender)



### Step 2 — Connect a Test Wallet (or Your Own)



Three pre-loaded test wallets are available:| Property | Value |



| User | 24-Word Mnemonic ||----------|-------|

|------|-----------------|

| **Alice Johnson** | `wolf call ramp month fashion wise bike sting cry oven stairs book flee access route gown donkey crunch quantum result comfort warm return elevator` || Algorithm | Gradient Boosting Classifier |---3. Submit an insurance claim with hospital stay & diagnosis details## 🎯 Overview

| **Bob Smith** | `gown notice anxiety dilemma casual such dismiss inner puzzle sun surround aim digital company work ridge disagree undo diesel cradle come chief damp make` |

| **Carol Williams** | `humble same cricket improve donate exercise game carry genuine life game book critic stock focus field oblige volcano east neither electric pulp collect tattoo` || Accuracy | **86.3%** |



**To import:** Open Lace → Restore Wallet → Paste mnemonic → Set password → Switch to Preprod| F1 Score | **0.80** |



> 💡 You can also connect **your own wallet** — the app auto-registers new users.| Dataset | 20,000 simulated healthcare claims |



### Step 3 — Submit a Claim| Features | Age, gender, diagnosis, stay duration, amount billed |## 🏗️ Architecture4. AI model predicts whether the claim is genuine or fraudulent (86.3% accuracy)



1. Open [http://178.128.212.100](http://178.128.212.100) → Connect Wallet → Set up profile| Balancing | SMOTE (Synthetic Minority Oversampling) |

2. Click **"Submit New Claim"**

3. Fill in hospital stay details (dates, diagnosis, amount)| Confidence Threshold | 90% (low-confidence genuine → rejected) |

4. Optionally upload prescription + receipt images for GPT-4o verification

5. Submit → AI results shown instantly| Training Script | `ml-service/export_model.py` |



### Step 4 — Get Your Payout| Training Notebook | `data/model_training.ipynb` (Google Colab) |```5. Optionally upload prescription + receipt images → GPT-4o Vision verifies them[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)



If approved: Claims History → Click **"Claim Amount"** → ADA sent within 60 seconds → View transaction on [CardanoScan](https://preprod.cardanoscan.io)



---### Model Training Notebook (`data/model_training.ipynb`)┌────────────────────────────────────────────────────────────┐



## 📁 Project Structure



```The notebook documents the full ML research pipeline, designed for **Google Colab**:│                     Nginx (port 80)                        │6. If approved → click "Claim Amount" to trigger a blockchain payout

HealthTrust/

├── client/                      # Vue 3 Frontend (SPA)

│   ├── src/

│   │   ├── components/          # ClaimForm, ClaimsList, NavBar, WalletSelector, etc.| Step | Cell | What It Does |│   /  → Vue SPA     /api/ → Python :8000                   │

│   │   ├── composables/         # useToast

│   │   ├── api.js               # API client|------|------|-------------|

│   │   ├── App.vue              # Root component (dashboard, modals, profile)

│   │   └── main.js              # Entry point| Install | Cell 1 | `!pip install imbalanced-learn` for SMOTE |│                     /service/ → Node.js :3001              │7. Within 60 seconds, real ADA is sent to your wallet from the treasuryHealthTrust is a decentralized insurance application that combines **AI fraud detection** with **Cardano blockchain** to automate claim verification and payouts. The system ensures transparency, immutability, and privacy.

│   ├── tailwind.config.js

│   └── vite.config.js| Import | Cell 2 | pandas, numpy, matplotlib, seaborn, scikit-learn (7 models), SMOTE |

│

├── ml-service/                  # Python ML Service| Load Data | Cell 3 | Upload CSV via `google.colab.files.upload()` |└──────┬──────────────────┬──────────────────┬───────────────┘

│   ├── main.py                  # FastAPI app setup

│   ├── routes.py                # All API endpoints| Feature Engineering | Cell 4 | Binary fraud target, StayDuration from dates |

│   ├── model_loader.py          # ML model loading + prediction

│   ├── database.py              # SQLAlchemy ORM models| Preprocessing | Cell 5 | 75/25 split, one-hot encoding, StandardScaler |       │                  │                  │8. Transaction is permanently recorded on Cardano Preprod with full metadata

│   ├── prescription_verifier.py # GPT-4o Vision image verification

│   ├── export_model.py          # Train & export ML model| Before SMOTE | Cell 6 | Shows imbalanced class distribution |

│   ├── requirements.txt

│   └── models/                  # Trained model artifacts (.pkl)| Apply SMOTE | Cell 7 | Oversamples minority fraud class to balance training data |┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼───────────────┐

│

├── server/blockchain-service/   # Node.js Blockchain Service| Train 7 Models | Cells 8–9 | Logistic, SVC, KNN, Decision Tree, Random Forest, Gradient Boosting, Voting Ensemble |

│   └── src/app.ts               # Express + MeshSDK + Blockfrost

│| Best Model | Cell 10 | Selects winner by F1 score |│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK   │```A decentralized insurance application that combines **AI fraud detection** with **Cardano blockchain** to automate claim verification and payouts. The system ensures transparency, immutability, and privacy while maintaining high accuracy in fraud detection.

├── automation-service/          # Go Automation Service

│   ├── database.go              # DB polling (60s) + orchestration| Metrics | Cell 11 | Confusion matrix for best model |

│   ├── blockchain.go            # HTTP client → blockchain service

│   └── crypto.go                # Blake2b-256 hashing| Visualizations | Cell 12 | 3 plots: Before/After SMOTE, F1 comparison, confusion matrix heatmap |│  TailwindCSS│   │  ML Service │   │  Blockchain Service  │

│

├── aiken-contracts/             # Aiken Smart Contract (Plutus V3)

│   ├── validators/

│   │   └── insurance_gatekeeper.ak---│  MeshSDK    │   │  Port 8000  │   │  Port 3001           │

│   ├── aiken.toml

│   └── build/                   # Compiled Plutus script

│

├── database/                    # PostgreSQL Schema## 🚀 Quick Start└─────────────┘   └──────┬──────┘   └──────┬───────────────┘

│   ├── schema.sql               # Core tables (users, claims, blockchain_transactions)

│   ├── seed.sql                 # Test users (alice, bob, carol)

│   └── migrations/              # Schema updates (003–005)

│### Prerequisites                         │                 │---### How It Works

├── treasury-wallet/             # Cardano wallet generation scripts

│

├── healthcare_fraud_final.ipynb # ML training notebook

├── start-all-services.sh        # Start all local services- **Node.js** ≥ 18 (with npm)                  ┌──────▼─────────────────▼────┐

└── README.md

```- **Python** ≥ 3.10



---- **Go** ≥ 1.21                  │     PostgreSQL (5432)        │



## 🔗 API Reference- **PostgreSQL** ≥ 14



### ML Service (`/api/` — Port 8000)- **Nginx** (for production reverse proxy)                  │     Database: HealthTrust    │



| Method | Endpoint | Description |- A **Blockfrost API key** (free at [blockfrost.io](https://blockfrost.io) — select Preprod)

|--------|----------|-------------|

| `GET` | `/` | Health check + model info |- An **OpenAI API key** (for GPT-4o image verification)                  └──────────────┬───────────────┘## 🚀 How to Use the App---

| `POST` | `/predict` | Submit claim → ML fraud prediction |

| `GET` | `/users/{wallet}` | Get user + claims (auto-registers new wallets) |

| `PUT` | `/users/{wallet}/profile` | Update user profile |

| `PUT` | `/claims/{id}/trigger-payout` | Trigger blockchain payout |### 1. Clone the Repository                                 │

| `POST` | `/verify-images` | Prescription vs receipt verification (GPT-4o) |

| `GET` | `/ada-price` | Live ADA/USD price from CoinMarketCap |

| `GET` | `/model/info` | ML model metadata + feature importance |

| `GET` | `/recent-activity` | Recent claims for landing page |```bash                  ┌──────────────▼───────────────┐



### Blockchain Service (`/service/` — Port 3001)git clone https://github.com/Yadurshan-R/HealthTrust.git



| Method | Endpoint | Description |cd HealthTrust                  │   Go Automation Service      │

|--------|----------|-------------|

| `GET` | `/health` | Treasury + smart contract balance |```

| `POST` | `/api/payout-transaction` | Build, sign, submit ADA transaction |

| `GET` | `/api/transaction/{txHash}` | Full transaction details from Blockfrost |                  │   Polls DB → triggers payouts│### Step 1 — Get a Cardano Wallet```

| `GET` | `/api/balance` | Treasury + smart contract balance |

| `GET` | `/api/epoch` | Current epoch, slot, block height |### 2. Set Up the Database



---                  │   every 60 seconds           │



## 🚀 Quick Start```bash



### Prerequisites# Create database and user                  └──────────────────────────────┘



- **Node.js** ≥ 18sudo -u postgres psql -c "CREATE USER healthtrust WITH PASSWORD 'your_password';"

- **Python** ≥ 3.10

- **Go** ≥ 1.21sudo -u postgres psql -c "CREATE DATABASE \"HealthTrust\" OWNER healthtrust;"```

- **PostgreSQL** ≥ 14

- **Nginx** (for production)

- A **Blockfrost API key** — free at [blockfrost.io](https://blockfrost.io) (select Preprod)

- An **OpenAI API key** — for GPT-4o image verification# Run schema and migrationsInstall one of these browser extensions and **switch to Preprod Testnet**:Patient submits claim → ML model checks for fraud (86.3% accuracy)> **Final Year Project** — AI-Powered Healthcare Insurance Fraud Detection on Blockchain

- A **CoinMarketCap API key** — for USD/ADA price conversion

sudo -u postgres psql -d HealthTrust -f database/schema.sql

### 1. Clone the Repository

sudo -u postgres psql -d HealthTrust -f database/seed.sql| Service | Language | Framework | Port |

```bash

git clone https://github.com/Yadurshan-R/HealthTrust.gitsudo -u postgres psql -d HealthTrust -f database/migrations/003_blockchain_transactions.sql

cd HealthTrust

```sudo -u postgres psql -d HealthTrust -f database/migrations/004_add_payout_date.sql|---------|----------|-----------|------|



### 2. Set Up the Databasesudo -u postgres psql -d HealthTrust -f database/migrations/005_add_image_verification.sql



```bash```| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | 80 (Nginx) |

sudo -u postgres psql -c "CREATE USER healthtrust WITH PASSWORD 'your_password';"

sudo -u postgres psql -c "CREATE DATABASE \"HealthTrust\" OWNER healthtrust;"



sudo -u postgres psql -d HealthTrust -f database/schema.sql### 3. Set Up Environment Variables| ML Service | Python 3.12 | FastAPI + Uvicorn | 8000 || Wallet | Link |    → If approved → Go automation triggers blockchain payout

sudo -u postgres psql -d HealthTrust -f database/seed.sql

sudo -u postgres psql -d HealthTrust -f database/migrations/003_blockchain_transactions.sql

sudo -u postgres psql -d HealthTrust -f database/migrations/004_add_payout_date.sql

sudo -u postgres psql -d HealthTrust -f database/migrations/005_add_image_verification.sqlEach service needs a `.env` file:| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 |

```



### 3. Set Up Environment Variables

**`ml-service/.env`**| Automation | Go 1.22 | stdlib + lib/pq | Background ||--------|------|

**`ml-service/.env`**

```env```env

DATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust

OPENAI_API_KEY=sk-your-openai-api-keyDATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust| Smart Contract | Aiken | Plutus V3 | On-chain |

CMC_API_KEY=your-coinmarketcap-api-key

```OPENAI_API_KEY=sk-your-openai-api-key



**`server/blockchain-service/.env`**```| Database | SQL | PostgreSQL 16 | 5432 || **Nami** | [namiwallet.io](https://namiwallet.io) |        → Treasury wallet sends ADA to patient's Cardano wallet## 🎯 Project Overview

```env

BLOCKFROST_API_KEY=preprodYOUR_BLOCKFROST_KEY

TREASURY_MNEMONIC=your 24 word treasury wallet mnemonic here

TREASURY_ADDRESS=addr_test1your_treasury_address**`server/blockchain-service/.env`**

PORT=3001

CARDANO_NETWORK=preprod```env

```

BLOCKFROST_API_KEY=preprodYOUR_BLOCKFROST_KEY---| **Eternl** | [eternl.io](https://eternl.io) |

**`automation-service/.env`** (or root `.env`)

```envTREASURY_MNEMONIC=your 24 word treasury wallet mnemonic here

DATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust

```TREASURY_ADDRESS=addr_test1your_treasury_address



> 💡 **Treasury Wallet:** Generate with `cd treasury-wallet && npm install && node generate-wallet.js`. Fund from [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/).PORT=3001



### 4. Install Dependencies & Start ServicesCARDANO_NETWORK=preprod## 🚀 Quick Start| **Lace** | [lace.io](https://lace.io) |            → On-chain metadata records the claim details permanently



```bash```

# ML Service (Python)

cd ml-service

python3 -m venv venv && source venv/bin/activate

pip install -r requirements.txt**`automation-service/.env`**

python export_model.py                    # First run: train & export model

uvicorn main:app --host 127.0.0.1 --port 8000```env### Prerequisites



# Blockchain Service (Node.js)DATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust

cd server/blockchain-service

npm install```

npx ts-node src/app.ts



# Automation (Go)

cd automation-service> 💡 **Treasury Wallet:** Generate a new one with `cd treasury-wallet && npm install && node generate-wallet.js`. Fund it from the [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/).- **Node.js** ≥ 18 (with npm)> ⚠️ You **must** be on **Cardano Preprod Testnet**, not Mainnet.```---

go mod tidy

go run database.go blockchain.go crypto.go



# Frontend (Vue 3)### 4. Install Dependencies & Start Services- **Python** ≥ 3.10

cd client

npm install

npm run build     # Production build → client/dist/

```**ML Service (Python):**- **Go** ≥ 1.21



### 5. Nginx Configuration (Production)```bash



```nginxcd ml-service- **PostgreSQL** ≥ 14

server {

    listen 80;python3 -m venv venv

    server_name your_domain_or_ip;

source venv/bin/activate- **Nginx** (for production reverse proxy)---

    location / {

        root /path/to/HealthTrust/client/dist;pip install -r requirements.txt

        try_files $uri $uri/ /index.html;

    }python export_model.py          # Train & export ML model (first run)- A **Blockfrost API key** (free at [blockfrost.io](https://blockfrost.io) — select Preprod)

    location /api/ {

        proxy_pass http://127.0.0.1:8000/;uvicorn main:app --host 127.0.0.1 --port 8000

    }

    location /service/ {```- An **OpenAI API key** (for GPT-4o image verification)

        proxy_pass http://127.0.0.1:3001/;

    }

}

```**Blockchain Service (Node.js):**



---```bash



## 🔐 Securitycd server/blockchain-service### 1. Clone the Repository### Step 2 — Use a Pre-Loaded Test Wallet (or Your Own)### Key FeaturesA decentralized insurance application that uses **AI fraud detection** combined with **Cardano blockchain** to automate claim verification and payouts. The system ensures transparency, immutability, and privacy while maintaining high accuracy in fraud detection.



- **Secrets** — Wallet mnemonics, API keys, DB passwords in `.env` files (gitignored)npm install

- **Backend isolation** — ML (8000) and Blockchain (3001) bound to `127.0.0.1` only

- **Nginx** — Only public-facing process (port 80)npx ts-node src/app.ts

- **Firewall** — UFW allows only ports 22, 80, 443

- **Privacy** — Blake2b-256 hashed user IDs on blockchain — no real names or integer IDs on-chain```

- **Smart contract** — Treasury signature required for every payout

```bash

---

**Automation Service (Go):**

## 🌐 Deployment

```bashgit clone https://github.com/Yadurshan-R/HealthTrust.git

Deployed on **DigitalOcean** at [http://178.128.212.100](http://178.128.212.100)

cd automation-service

| Component | Details |

|-----------|---------|go mod tidycd HealthTrustI have created **3 test wallets** with pre-generated mnemonics that you can import directly into your wallet extension. These are ready to use on Preprod.

| Server | DigitalOcean Droplet — Ubuntu 22.04, 2GB RAM |

| Services | 3 systemd units (`healthtrust-ml`, `healthtrust-blockchain`, `healthtrust-automation`) |go run database.go blockchain.go crypto.go

| Database | PostgreSQL 16 |

| Network | Cardano Preprod Testnet |``````



```bash

# Deploy new changes

bash deploy.sh   # Builds frontend → syncs to server → restarts services**Frontend (Vue 3):**



# Check service status```bash

sudo systemctl status healthtrust-ml healthtrust-blockchain healthtrust-automation

cd client### 2. Set Up the Database

# View logs

sudo journalctl -u healthtrust-ml -fnpm install

```

npm run dev        # Development (localhost:5173)| # | User | 24-Word Mnemonic |- 🤖 **AI Fraud Detection** — Gradient Boosting classifier trained on 30,000+ claims## ✨ Key Features

---

# — OR —

## 🔗 Resources

npm run build      # Production build → dist/```bash

- [Cardano Documentation](https://docs.cardano.org)

- [MeshSDK](https://meshjs.dev)```

- [Blockfrost API](https://blockfrost.io)

- [Aiken Smart Contracts](https://aiken-lang.org)# Create database and user|---|------|-----------------|

- [Lucid Evolution](https://github.com/Anastasia-Labs/lucid-evolution) — recommended for Plutus V3 script spending

- [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/)### 5. Nginx Configuration (Production)

- [CardanoScan (Preprod)](https://preprod.cardanoscan.io)

sudo -u postgres psql -c "CREATE USER healthtrust WITH PASSWORD 'your_password';"

---

```nginx

## 📄 License

server {sudo -u postgres psql -c "CREATE DATABASE \"HealthTrust\" OWNER healthtrust;"| 1 | **Alice Johnson** | `wolf call ramp month fashion wise bike sting cry oven stairs book flee access route gown donkey crunch quantum result comfort warm return elevator` |- ⛓️ **Blockchain Payouts** — Automated on-chain ADA transactions via MeshSDK

MIT License — see [LICENSE](LICENSE) for details.

    listen 80;

---

    server_name your_domain_or_ip;

*Built by [Yadurshan R](https://github.com/Yadurshan-R) — Final Year Project 2025/2026*



    location / {# Run schema and migrations| 2 | **Bob Smith** | `gown notice anxiety dilemma casual such dismiss inner puzzle sun surround aim digital company work ridge disagree undo diesel cradle come chief damp make` |

        root /path/to/HealthTrust/client/dist;

        try_files $uri $uri/ /index.html;sudo -u postgres psql -d HealthTrust -f database/schema.sql

    }

sudo -u postgres psql -d HealthTrust -f database/seed.sql| 3 | **Carol Williams** | `humble same cricket improve donate exercise game carry genuine life game book critic stock focus field oblige volcano east neither electric pulp collect tattoo` |- 📜 **Aiken Smart Contract** — Plutus V3 Insurance Gatekeeper validator (compiled & deployed)### Key Features

    location /api/ {

        proxy_pass http://127.0.0.1:8000/;sudo -u postgres psql -d HealthTrust -f database/migrations/003_blockchain_transactions.sql

    }

sudo -u postgres psql -d HealthTrust -f database/migrations/004_add_payout_date.sql

    location /service/ {

        proxy_pass http://127.0.0.1:3001/;sudo -u postgres psql -d HealthTrust -f database/migrations/005_add_image_verification.sql

    }

}```**How to import a test wallet:**- 🔒 **Privacy Preserved** — Blake2b-256 hashing for user identity on public ledger

```



---

### 3. Set Up Environment Variables

## 🎮 How to Use the App



### Step 1 — Get a Cardano Wallet

Each service needs a `.env` file. Create them as follows:1. Open your wallet extension (e.g., Nami or Eternl)- 📋 **On-Chain Records** — Every payout recorded with CIP-20 metadata (label 674)- **AI Fraud Detection** — 86.3% accuracy using Gradient Boosting classifier

Install one of these browser extensions and **switch to Preprod Testnet**:



| Wallet | Link |

|--------|------|**`ml-service/.env`**2. Click **"Import"** or **"Restore Wallet"**

| **Nami** | [namiwallet.io](https://namiwallet.io) |

| **Eternl** | [eternl.io](https://eternl.io) |```env

| **Lace** | [lace.io](https://lace.io) |

DATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust3. Paste any of the 24-word mnemonics above- ⚡ **60-Second Automation** — Go service continuously polls and processes approved claims

> ⚠️ You **must** be on **Cardano Preprod Testnet**, not Mainnet.

OPENAI_API_KEY=sk-your-openai-api-key

### Step 2 — Use a Test Wallet (or Your Own)

```4. Set a spending password

Three pre-loaded test wallets are available. Import any 24-word mnemonic into your wallet extension:



| User | 24-Word Mnemonic |

|------|-----------------|**`server/blockchain-service/.env`**5. Switch the network to **Preprod Testnet**- 🖼️ **Image Verification** — GPT-4o Vision compares prescriptions against pharmacy receipts- **Blockchain Payouts** — Automated on-chain transactions via MeshSDK on Cardano Preprod- ✅ **AI Fraud Detection** - 86.3% accuracy using Gradient Boosting

| **Alice Johnson** | `wolf call ramp month fashion wise bike sting cry oven stairs book flee access route gown donkey crunch quantum result comfort warm return elevator` |

| **Bob Smith** | `gown notice anxiety dilemma casual such dismiss inner puzzle sun surround aim digital company work ridge disagree undo diesel cradle come chief damp make` |```env

| **Carol Williams** | `humble same cricket improve donate exercise game carry genuine life game book critic stock focus field oblige volcano east neither electric pulp collect tattoo` |

BLOCKFROST_API_KEY=preprodYOUR_BLOCKFROST_KEY

**To import:** Open wallet → Import/Restore → Paste mnemonic → Set password → Switch to Preprod

TREASURY_MNEMONIC=your 24 word treasury wallet mnemonic here

> 💡 You can also connect **your own wallet** — the app auto-registers new wallets.

TREASURY_ADDRESS=addr_test1your_treasury_address> 💡 **Don't want to import?** You can also use **your own Cardano wallet** — just connect it and the app will auto-register you. A profile setup popup will appear for you to enter your name, age, and gender.

### Step 3 — Submit a Claim

PORT=3001

1. Open the app → Connect Wallet → Set up profile (first time only)

2. Click **"Submit New Claim"**CARDANO_NETWORK=preprod

3. Fill in hospital stay details (dates, diagnosis, amount)

4. Optionally upload prescription + receipt images for verification```

5. Submit → AI results shown instantly

------- **Image Verification** — GPT-4o Vision compares prescriptions against pharmacy receipts- ✅ **Blockchain Payouts** - Automated on-chain transactions via MeshSDK

### Step 4 — Get Your Payout

**`automation-service/.env`**

If approved: Claims History → Click **"Claim Amount"** → ADA sent within 60 seconds → View transaction on CardanoScan

```env

---

DATABASE_URL=postgresql://healthtrust:your_password@localhost:5432/HealthTrust

## 📁 Project Structure

```### Step 3 — Open the App & Connect

```

HealthTrust/

├── client/                      # Vue 3 Frontend (SPA)

│   ├── src/> 💡 **Treasury Wallet:** You can generate a new Cardano wallet by running `cd treasury-wallet && npm install && node generate-wallet.js`. Fund it with test ADA from the [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/).

│   │   ├── components/          # ClaimForm, ClaimsList, NavBar, WalletSelector, etc.

│   │   ├── composables/         # useToast

│   │   ├── api.js               # API client

│   │   ├── App.vue              # Root component### 4. Install Dependencies & Start Services1. Go to **[http://178.128.212.100](http://178.128.212.100)**## 🏗️ Architecture- **Privacy Preserved** — Blake2b hashing for public payout records- ✅ **Privacy Preserved** - Blake2b hashing for user data

│   │   └── main.js              # Entry point

│   ├── tailwind.config.js

│   └── vite.config.js

│**ML Service (Python):**2. Click **"Connect Wallet"** in the top navigation bar

├── ml-service/                  # Python ML Service

│   ├── main.py                  # FastAPI app setup```bash

│   ├── routes.py                # All API endpoints

│   ├── model_loader.py          # ML model loading + predictioncd ml-service3. Select your wallet provider (Nami / Eternl / Lace)

│   ├── database.py              # SQLAlchemy ORM models

│   ├── prescription_verifier.py # GPT-4o Vision image verificationpython3 -m venv venv

│   ├── export_model.py          # Train & export ML model

│   └── requirements.txtsource venv/bin/activate4. Approve the connection in your wallet popup

│

├── server/blockchain-service/   # Node.js Blockchain Servicepip install -r requirements.txt

│   └── src/app.ts               # Express + MeshSDK + Blockfrost

│```- **Transparent Records** — All payouts immutably recorded on-chain (metadata label 674)- ✅ **Transparent Records** - All payouts recorded on Cardano Preprod

├── automation-service/          # Go Automation Service

│   ├── database.go              # DB polling (60s) + orchestration# Train and export the ML model (required on first run)

│   ├── blockchain.go            # HTTP client → blockchain service

│   └── crypto.go                # Blake2b-256 hashingpython export_model.py---

│

├── aiken-contracts/             # Aiken Smart Contract (Plutus V3)

│   └── validators/

│       └── insurance_gatekeeper.ak# Start the service┌────────────────────────────────────────────────────────────┐

│

├── database/                    # PostgreSQL Schemauvicorn main:app --host 127.0.0.1 --port 8000

│   ├── schema.sql               # Core tables

│   ├── seed.sql                 # Test users```### Step 4 — Set Up Your Profile (First-Time Users)

│   └── migrations/              # Schema updates

│

├── data/                        # ML Training

│   ├── healthcare_claims.csv    # 20,000-row training dataset**Blockchain Service (Node.js):**│                     Nginx (port 80)                        │- **60-Second Automation** — Go service polls and processes approved payouts continuously- ✅ **Real-time Processing** - 60-second automation polling

│   └── model_training.ipynb     # Google Colab notebook (SMOTE + 7 models)

│```bash

├── treasury-wallet/             # Wallet generation scripts

│cd server/blockchain-serviceIf this is your first time connecting, a **Profile Setup modal** will appear:

├── deploy/                      # Server deployment configs & systemd units

│npm install

├── deploy.sh                    # One-command deploy to server

└── start.sh                     # Local development start/stopnpx ts-node src/app.ts│   /  → Vue SPA     /api/ → Python :8000                   │

```

```

---

- **Full Name** — e.g., "John Doe"

## 🔗 API Reference

**Automation Service (Go):**

### ML Service (`/api/` — Port 8000)

```bash- **Age** — e.g., 30│                     /service/ → Node.js :3001              │

| Method | Endpoint | Description |

|--------|----------|-------------|cd automation-service

| `GET` | `/` | Health check + model info |

| `POST` | `/predict` | Submit claim → ML fraud prediction |go mod tidy- **Gender** — Male or Female

| `GET` | `/users/{wallet}` | Get user + claims (auto-registers new wallets) |

| `PUT` | `/users/{wallet}/profile` | Update user profile |go run database.go blockchain.go crypto.go

| `PUT` | `/claims/{id}/trigger-payout` | Trigger blockchain payout |

| `POST` | `/verify-images` | Prescription vs receipt verification (GPT-4o) |```└──────┬──────────────────┬──────────────────┬───────────────┘

| `GET` | `/model/info` | ML model metadata + feature importance |

| `GET` | `/recent-activity` | Recent claims for landing page |



### Blockchain Service (`/service/` — Port 3001)**Frontend (Vue 3):**Click **Save & Continue** — you're now registered!



| Method | Endpoint | Description |```bash

|--------|----------|-------------|

| `GET` | `/health` | Treasury balance + wallet info |cd client       │                  │                  │------

| `POST` | `/api/payout-transaction` | Build, sign, submit ADA transaction |

| `GET` | `/api/transaction/{txHash}` | Full transaction details from Blockfrost |npm install

| `GET` | `/api/balance` | Treasury + smart contract balance |

| `GET` | `/api/epoch` | Current epoch, slot, block height |npm run dev        # Development (localhost:5173)> Returning users are automatically recognized by their wallet address.



---# — OR —



## 📜 Aiken Smart Contractnpm run build      # Production build → dist/┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼───────────────┐



The **Insurance Gatekeeper** is a Plutus V3 validator:```



```aiken---

validator insurance_gatekeeper {

  spend(datum, _redeemer, _self) {### 5. Nginx Configuration (Production)

    expect datum: InsuranceDatum

    list.has(tx.extra_signatories, treasury_pkh)│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK   │

      && !is_empty(datum.hashed_user_id)

  }```nginx

}

```server {### Step 5 — Explore the Dashboard



| Property | Value |    listen 80;

|----------|-------|

| Script Address | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |    server_name your_domain_or_ip;│  TailwindCSS│   │  ML Service │   │  Blockchain Service  │

| Language | Plutus V3 (Conway era) |

| Status | Compiled & deployed on Preprod |



> **Note:** Script spending is currently disabled due to a MeshSDK v1 limitation with Plutus V3 CBOR serialization. Payouts use the treasury wallet directly (same key, equivalent security).    # Vue SPAOnce connected, your dashboard shows:



---    location / {



## 🔐 Security        root /path/to/HealthTrust/client/dist;│  MeshSDK    │   │  Port 8000  │   │  Port 3001           │## 🏗️ Architecture## 🏗️ Architecture



- **Secrets** — Wallet mnemonics, API keys, DB passwords in `.env` files (gitignored)        try_files $uri $uri/ /index.html;

- **Backend isolation** — ML (8000) and Blockchain (3001) bound to `127.0.0.1` only

- **Nginx** — Only public-facing process (port 80)    }| Section | What It Does |

- **Firewall** — UFW allows only ports 22, 80, 443

- **Privacy** — Blake2b-256 hashed user IDs on public blockchain records

- **Smart contract** — Treasury signature required for every payout

    # Python ML Service|---------|-------------|└─────────────┘   └──────┬──────┘   └──────┬───────────────┘

---

    location /api/ {

## 🌐 Deployment

        proxy_pass http://127.0.0.1:8000/;| 🟢 **Welcome Card** | Shows your name, connected wallet, insurance expiry date, and premium amount |

Deployed on **DigitalOcean** at [http://178.128.212.100](http://178.128.212.100)

    }

| Component | Details |

|-----------|---------|| 📊 **Dashboard Stats** | 4 clickable cards — **Total Claims**, **Approved**, **Rejected**, **Pending Payout** (click any to see filtered list) |                         │                 │

| Server | DigitalOcean Droplet — Ubuntu 22.04, 2GB RAM |

| Services | 3 systemd units (auto-start on boot) |    # Node.js Blockchain Service

| Database | PostgreSQL 16 |

| Network | Cardano Preprod Testnet |    location /service/ {| 📋 **Submit New Claim** | Opens the multi-step claim submission form |



**Quick deploy:**        proxy_pass http://127.0.0.1:3001/;

```bash

bash deploy.sh   # Builds frontend → syncs to server → restarts services    }| 📜 **View Claims History** | Modal with all your past claims, statuses, and transaction hashes |                  ┌──────▼─────────────────▼────┐

```

}

---

```

## 📄 License



MIT License — see [LICENSE](LICENSE) for details.

------                  │     PostgreSQL (5432)        │``````

---



*Built by Yadurshan as a Final Year Project — 2025/2026*

## 🎮 How to Use the App



### Step 1 — Get a Cardano Wallet### Step 6 — Submit an Insurance Claim                  │     Database: HealthTrust    │



Install one of these browser extensions and **switch to Preprod Testnet**:



| Wallet | Link |Click **"Submit New Claim"** → the form has 3 steps:                  └──────────────┬───────────────┘┌──────────────────────────────────────────────────────────────────┐┌─────────────────────────────────────────────────────────┐

|--------|------|

| **Nami** | [namiwallet.io](https://namiwallet.io) |

| **Eternl** | [eternl.io](https://eternl.io) |

| **Lace** | [lace.io](https://lace.io) |#### Step 1 — Hospital Stay Details                                 │



> ⚠️ You **must** be on **Cardano Preprod Testnet**, not Mainnet.- **Admission Date** — when you were admitted



### Step 2 — Use a Test Wallet (or Your Own)- **Discharge Date** — when you were discharged                  ┌──────────────▼───────────────┐│                        Nginx (port 80)                           ││                Vue 3 Frontend (client/)                 │



Three pre-loaded test wallets are available. Import any 24-word mnemonic into your wallet extension:- Days hospitalized is auto-calculated



| User | 24-Word Mnemonic |                  │   Go Automation Service      │

|------|-----------------|

| **Alice Johnson** | `wolf call ramp month fashion wise bike sting cry oven stairs book flee access route gown donkey crunch quantum result comfort warm return elevator` |#### Step 2 — Treatment & Billing

| **Bob Smith** | `gown notice anxiety dilemma casual such dismiss inner puzzle sun surround aim digital company work ridge disagree undo diesel cradle come chief damp make` |

| **Carol Williams** | `humble same cricket improve donate exercise game carry genuine life game book critic stock focus field oblige volcano east neither electric pulp collect tattoo` |- **Primary Diagnosis** — choose from:                  │   Polls DB → triggers payouts││  /  → Vue SPA    /api/ → Python :8000    /service/ → Node :3001  ││          User submits claims, views results             │



**To import:** Open wallet → Import/Restore → Paste mnemonic → Set password → Switch to Preprod  - Pregnancy & Childbirth



> 💡 You can also connect **your own wallet** — the app auto-registers new wallets.  - Hypertension                  │   every 60 seconds           │



### Step 3 — Submit a Claim  - Diabetes Mellitus



1. Open the app → Connect Wallet → Set up profile (first time only)  - Pneumonia                  └──────────────────────────────┘└──────────┬───────────────┬───────────────────┬───────────────────┘└──────────┬──────────────────────────────────────────────┘

2. Click **"Submit New Claim"**

3. Fill in hospital stay details (dates, diagnosis, amount)  - Gastroenteritis

4. Optionally upload prescription + receipt images for verification

5. Submit → AI results shown instantly  - Cesarean Section```



### Step 4 — Get Your Payout  - Cataract Surgery



If approved: Claims History → Click **"Claim Amount"** → ADA sent within 60 seconds → View transaction on CardanoScan  - Other Medical Condition           │               │                   │           │



---- **Total Amount Billed** — in ₳ (ADA)



## 📁 Project Structure---



```#### Step 3 — Supporting Documents (Optional but Recommended)

HealthTrust/

├── client/                      # Vue 3 Frontend (SPA)- Upload a **Hospital Receipt** (image or PDF)    ┌──────▼──────┐ ┌──────▼──────┐  ┌─────────▼──────────┐           ├─────────────┬──────────────┬─────────────────┐

│   ├── src/

│   │   ├── components/          # ClaimForm, ClaimsList, NavBar, WalletSelector, etc.- Upload a **Doctor's Prescription** (image or PDF)

│   │   ├── composables/         # useToast

│   │   ├── api.js               # API client- If both are uploaded, **GPT-4o Vision AI** compares them and produces an **image verification score** (0–100%)## 📁 Project Structure

│   │   ├── App.vue              # Root component

│   │   └── main.js              # Entry point

│   ├── tailwind.config.js

│   └── vite.config.jsClick **Submit** → the AI model instantly returns:    │  Vue 3 +    │ │  FastAPI    │  │  Express + MeshSDK  │           ▼             ▼              ▼                 ▼

│

├── ml-service/                  # Python ML Service- ✅ **Genuine** (with confidence %) — claim is approved

│   ├── main.py                  # FastAPI app setup

│   ├── routes.py                # All API endpoints- ❌ **Fraudulent** (with confidence %) — claim is rejected| Service | Language | Framework | Port | Role |

│   ├── model_loader.py          # ML model loading + prediction

│   ├── database.py              # SQLAlchemy ORM models

│   ├── prescription_verifier.py # GPT-4o Vision image verification

│   ├── export_model.py          # Train & export ML model---|---------|----------|-----------|------|------|    │  TailwindCSS│ │  ML Service │  │  Blockchain Service │    ┌──────────┐  ┌───────────┐  ┌───────────┐   ┌────────────┐

│   └── requirements.txt

│

├── server/blockchain-service/   # Node.js Blockchain Service

│   └── src/app.ts               # Express + MeshSDK + Blockfrost### Step 7 — Get Your Payout (ADA to Your Wallet)| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | — (Nginx) | User interface, wallet connection |

│

├── automation-service/          # Go Automation Service

│   ├── database.go              # DB polling (60s) + orchestration

│   ├── blockchain.go            # HTTP client → blockchain serviceIf your claim is marked as **genuine**:| ML Service | Python 3.10 | FastAPI + Uvicorn | 8000 | Fraud prediction, image verification, CRUD |    │  MeshSDK    │ │  Port 8000  │  │  Port 3001          │    │ML Service│  │Go Service │  │Blockchain │   │ PostgreSQL │

│   └── crypto.go                # Blake2b-256 hashing

│

├── aiken-contracts/             # Aiken Smart Contract (Plutus V3)

│   └── validators/1. Open **Claims History** (or click the **"Pending Payout"** stat card)| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 | Cardano transaction building & submission |

│       └── insurance_gatekeeper.ak

│2. Find your approved claim

├── database/                    # PostgreSQL Schema

│   ├── schema.sql               # Core tables3. Click the **"Claim Amount"** button| Automation | Go 1.25 | stdlib | — | Polls DB, triggers payouts via blockchain service |    └─────────────┘ └──────┬──────┘  └─────────┬───────────┘    │(Python)  │  │(Automation)│  │(Node.js)  │   │ Database   │

│   ├── seed.sql                 # Test users

│   └── migrations/              # Schema updates4. The Go automation service picks it up within **60 seconds**

│

├── data/5. Real **ADA is sent from the treasury wallet to your connected wallet**| Smart Contract | Aiken 1.1.19 | Plutus V3 | — | On-chain Insurance Gatekeeper validator |

│   └── healthcare_claims.csv    # 20,000-row training dataset

│6. A **transaction hash** appears — click it to verify on [CardanoScan (Preprod)](https://preprod.cardanoscan.io)

├── treasury-wallet/             # Wallet generation scripts

│   ├── generate-wallet.js       # Treasury wallet| Database | — | PostgreSQL 18 | 5432 | Users, claims, transactions, payouts |                           │                   │    │Port 8000 │  │Background │  │Port 3001  │   │ Port 5432  │

│   └── generate-user-wallets.js # Test user wallets

│The on-chain transaction includes **CIP-20 metadata** (label 674) with:

├── deploy/                      # Server deployment configs

│   ├── setup-server.sh          # Ubuntu setup- Claim ID, User ID, Amount in ADA

│   ├── setup-database.sh        # PostgreSQL setup

│   ├── setup-services.sh        # Service installation- ML prediction status, Diagnosis

│   ├── setup-nginx.sh           # Nginx configuration

│   ├── healthtrust-ml.service   # systemd unit files- Patient name (hashed for privacy), Smart contract reference```                    ┌──────▼───────────────────▼────┐    └──────────┘  └───────────┘  └─────┬─────┘   └────────────┘

│   ├── healthtrust-blockchain.service

│   └── healthtrust-go.service- Timestamp and network

│

├── deploy.sh                    # One-command deploy to serverhealthtrust/

└── start.sh                     # Local development start/stop

```> 💰 The treasury wallet holds **~4,000+ tADA** on Cardano Preprod for payouts.



---├── client/                     # Vue 3 Frontend (SPA)                    │       PostgreSQL (5432)        │                                        │



## 🔗 API Reference---



### ML Service (`/api/` — Port 8000)│   ├── src/



| Method | Endpoint | Description |## ✨ Key Features

|--------|----------|-------------|

| `GET` | `/` | Health check + model info |│   │   ├── components/         # ClaimForm, ClaimsList, NavBar, etc.                    │       Database: HealthTrust    │                                        ▼

| `POST` | `/predict` | Submit claim → ML fraud prediction |

| `GET` | `/users/{wallet}` | Get user + claims (auto-registers new wallets) || Feature | Description |

| `PUT` | `/users/{wallet}/profile` | Update user profile |

| `PUT` | `/claims/{id}/trigger-payout` | Trigger blockchain payout ||---------|-------------|│   │   ├── composables/        # useToast

| `POST` | `/verify-images` | Prescription vs receipt verification (GPT-4o) |

| `GET` | `/model/info` | ML model metadata + feature importance || 🤖 **AI Fraud Detection** | Gradient Boosting classifier trained on 30,000+ claims — **86.3% accuracy** |

| `GET` | `/recent-activity` | Recent claims for landing page |

| 🖼️ **Image Verification** | GPT-4o Vision compares prescription against pharmacy receipt for authenticity |│   │   ├── api.js              # API client                    └──────────────┬────────────────┘                              ┌──────────────────┐

### Blockchain Service (`/service/` — Port 3001)

| ⛓️ **Blockchain Payouts** | Automated real ADA transactions on Cardano Preprod via MeshSDK |

| Method | Endpoint | Description |

|--------|----------|-------------|| 📋 **On-Chain Records** | Every payout permanently recorded with CIP-20 metadata (label 674) |│   │   ├── App.vue             # Root component

| `GET` | `/health` | Treasury balance + wallet info |

| `POST` | `/api/payout-transaction` | Build, sign, submit ADA transaction || 🔒 **Privacy Preserved** | Blake2b-256 hashing for user identity on public ledger |

| `GET` | `/api/transaction/{txHash}` | Full transaction details from Blockfrost |

| `GET` | `/api/balance` | Treasury + smart contract balance || ⚡ **60-Second Automation** | Go service polls database and processes approved payouts continuously |│   │   └── main.js             # Entry point                                   │                              │ Cardano Preprod  │

| `GET` | `/api/epoch` | Current epoch, slot, block height |

| 🔓 **Open Registration** | Anyone with a Cardano wallet can join — no pre-registration needed |

---

| 📜 **Aiken Smart Contract** | Plutus V3 Insurance Gatekeeper validator compiled & deployed on-chain |│   ├── tailwind.config.js

## 🧠 ML Model

| 📊 **Interactive Dashboard** | Clickable stat cards, claim history, real-time status tracking |

| Property | Value |

|----------|-------|│   └── vite.config.js                    ┌──────────────▼────────────────┐                              │  Testnet         │

| Algorithm | Gradient Boosting Classifier |

| Accuracy | **86.3%** |---

| F1 Score | **0.80** |

| Dataset | 20,000 simulated healthcare claims |│

| Features | Age, gender, diagnosis, stay duration, amount billed |

| Confidence Threshold | 90% (low-confidence genuine → rejected) |## 🏗️ Architecture

| Training Script | `ml-service/export_model.py` |

├── ml-service/                 # Python ML Service                    │    Go Automation Service       │                              └──────────────────┘

---

```

## 📜 Aiken Smart Contract

┌────────────────────────────────────────────────────────────┐│   ├── main.py                 # FastAPI endpoints

The **Insurance Gatekeeper** is a Plutus V3 validator:

│                     Nginx (port 80)                        │

```aiken

validator insurance_gatekeeper {│   /  → Vue SPA     /api/ → Python :8000                   ││   ├── model_loader.py         # Model loading utilities                    │    Polls DB → triggers payouts │```

  spend(datum, _redeemer, _self) {

    expect datum: InsuranceDatum│                     /service/ → Node.js :3001              │

    // Must be signed by treasury wallet + valid user hash

    list.has(tx.extra_signatories, treasury_pkh)└──────┬──────────────────┬──────────────────┬───────────────┘│   ├── database.py             # PostgreSQL connection

      && !is_empty(datum.hashed_user_id)

  }       │                  │                  │

}

```┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼───────────────┐│   ├── prescription_verifier.py # GPT-4o image verification                    │    every 60 seconds            │



| Property | Value |│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK   │

|----------|-------|

| Script Address | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |│  TailwindCSS│   │  ML Service │   │  Blockchain Service  ││   ├── export_model.py         # Re-train & export model

| Language | Plutus V3 (Conway era) |

| Status | Compiled & deployed on Preprod |│  MeshSDK    │   │  Port 8000  │   │  Port 3001           │



> **Note:** Script spending is currently disabled due to a MeshSDK v1 limitation with Plutus V3 CBOR serialization. Payouts use the treasury wallet directly (same key required, equivalent security).└─────────────┘   └──────┬──────┘   └──────┬───────────────┘│   ├── requirements.txt                    └───────────────────────────────┘---



---                         │                 │



## 🔐 Security                  ┌──────▼─────────────────▼────┐│   └── models/                 # Trained model artifacts (.pkl)



- **Secrets** — Wallet mnemonics, API keys, DB passwords in `.env` files (gitignored)                  │     PostgreSQL (5432)        │

- **Backend isolation** — ML (8000) and Blockchain (3001) bound to `127.0.0.1` only

- **Nginx** — Only public-facing process (port 80)                  │     Database: HealthTrust    ││```

- **Firewall** — UFW allows only ports 22, 80, 443

- **Privacy** — Blake2b-256 hashed user IDs on public blockchain records                  └──────────────┬───────────────┘

- **Smart contract** — Treasury signature required for every payout

                                 │├── server/

---

                  ┌──────────────▼───────────────┐

## 🌐 Deployment

                  │   Go Automation Service      ││   └── blockchain-service/     # Node.js Blockchain Service## 📁 Project Structure

Deployed on **DigitalOcean** at [http://178.128.212.100](http://178.128.212.100)

                  │   Polls DB → triggers payouts│

| Component | Details |

|-----------|---------|                  │   every 60 seconds           ││       ├── src/app.ts          # Express + MeshSDK + Blockfrost

| Server | DigitalOcean Droplet — Ubuntu 22.04, 2GB RAM |

| Services | 3 systemd units (auto-start on boot) |                  └──────────────────────────────┘

| Database | PostgreSQL 16 |

| Network | Cardano Preprod Testnet |```│       ├── tsconfig.json| Service | Language | Framework | Port | Role |



**Quick deploy:**

```bash

bash deploy.sh   # Builds frontend → syncs to server → restarts services| Service | Language | Framework | Port |│       └── package.json

```

|---------|----------|-----------|------|

---

| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | 80 (Nginx) |│|---------|----------|-----------|------|------|```

## 📄 License

| ML Service | Python 3.12 | FastAPI + Uvicorn | 8000 |

MIT License — see [LICENSE](LICENSE) for details.

| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 |├── automation-service/         # Go Automation Service

---

| Automation | Go 1.22 | stdlib | Background |

*Built by Yadurshan as a Final Year Project — 2025/2026*

| Smart Contract | Aiken 1.1.19 | Plutus V3 | On-chain |│   ├── blockchain.go           # Payout logic| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | — (Nginx) | User interface, wallet connection |model_1/

| Database | SQL | PostgreSQL 16 | 5432 |

│   ├── crypto.go               # Blake2b hashing

---

│   ├── database.go             # DB polling| ML Service | Python 3.10 | FastAPI + Uvicorn | 8000 | Fraud prediction, CRUD, image verification |├── client/                      # Vue 3 Frontend

## 📁 Project Structure

│   └── go.mod

```

healthtrust/│| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 | Cardano transaction building & submission |│   ├── src/

├── client/                      # Vue 3 Frontend (SPA)

│   ├── src/├── aiken-contracts/            # Aiken Smart Contract (Plutus V3)

│   │   ├── components/          # ClaimForm, ClaimsList, NavBar, WalletSelector, etc.

│   │   ├── composables/         # useToast│   ├── validators/| Automation | Go 1.25 | stdlib | — | Polls DB, triggers payouts via Blockchain Service |│   │   ├── components/         # Vue components

│   │   ├── api.js               # API client

│   │   ├── App.vue              # Root component (dashboard, modals, profile setup)│   │   └── insurance_gatekeeper.ak   # On-chain validator

│   │   └── main.js              # Entry point

│   ├── tailwind.config.js│   ├── aiken.toml| Database | — | PostgreSQL 18 | 5432 | Users, claims, transactions, payouts |│   │   ├── views/              # Page views

│   └── vite.config.js

││   └── build/                  # Compiled plutus.json

├── ml-service/                  # Python ML Service

│   ├── main.py                  # FastAPI app setup││   │   └── App.vue             # Root component

│   ├── routes.py                # All API endpoints (predict, users, claims, images)

│   ├── model_loader.py          # Model loading utilities├── database/                   # Database schemas

│   ├── database.py              # PostgreSQL ORM (SQLAlchemy)

│   ├── prescription_verifier.py # GPT-4o Vision image verification│   ├── schema.sql              # Core tables---│   └── package.json

│   ├── export_model.py          # Re-train & export model

│   ├── requirements.txt│   ├── seed.sql                # Initial data (3 users with wallets)

│   └── models/                  # Trained model artifacts (.pkl)

││   └── migrations/             # Schema updates│

├── server/

│   └── blockchain-service/      # Node.js Blockchain Service│

│       ├── src/app.ts           # Express + MeshSDK + Blockfrost

│       ├── tsconfig.json├── treasury-wallet/            # Cardano wallet management## 📁 Project Structure├── server/

│       └── package.json

││   ├── generate-wallet.js

├── automation-service/          # Go Automation Service

│   ├── blockchain.go            # Main loop + payout logic│   ├── generate-user-wallets.js│   ├── blockchain-service/     # Node.js + MeshSDK

│   ├── crypto.go                # Blake2b-256 hashing

│   ├── database.go              # DB polling every 60 seconds│   └── users/                  # User wallet files

│   └── go.mod

││```│   │   ├── src/app.ts         # Cardano integration

├── aiken-contracts/             # Aiken Smart Contract (Plutus V3)

│   ├── validators/├── data/                       # Training data & notebook

│   │   └── insurance_gatekeeper.ak

│   ├── aiken.toml│   ├── healthcare_claims.csvhealthtrust/│   │   └── package.json

│   └── build/                   # Compiled plutus.json

││   └── model_training.ipynb

├── database/                    # Database schemas & migrations

│   ├── schema.sql               # Core tables (users, claims, blockchain_transactions)│├── client/                     # Vue 3 Frontend (SPA)│   └── go-api/                 # Go API (future)

│   ├── seed.sql                 # Initial seed data

│   └── migrations/              # Schema updates (003–005)├── start.sh                    # Start/stop all services

│

├── treasury-wallet/             # Cardano wallet management├── .env                        # Environment variables│   ├── src/│

│   ├── generate-wallet.js

│   ├── generate-user-wallets.js└── .gitignore

│   └── users/                   # Generated test wallet files (alice, bob, carol)

│```│   │   ├── components/         # Vue components (ClaimForm, ClaimsList, NavBar, etc.)├── ml-service/                 # Python ML Service

├── deploy.sh                    # One-command deploy to DigitalOcean

├── start-all-services.sh        # Start all local services

└── README.md                    # ← You are here

```---│   │   ├── composables/        # Composable hooks (useToast)│   ├── app.py                 # Flask API



---



## 📜 Aiken Smart Contract## 📜 Aiken Smart Contract│   │   ├── api.js              # API client│   └── voting_classifier_model.pkl



The **Insurance Gatekeeper** is a Plutus V3 validator compiled with Aiken v1.1.19:



```aikenThe **Insurance Gatekeeper** is a Plutus V3 validator compiled with Aiken v1.1.19. It enforces on-chain rules for insurance payouts.│   │   ├── App.vue             # Root component│

validator insurance_gatekeeper {

  spend(datum, _redeemer, _self) {

    expect datum: InsuranceDatum

    // Must be signed by treasury wallet + have non-empty hashed user ID### Validator Logic│   │   └── main.js             # Entry point├── database/

    list.has(tx.extra_signatories, treasury_pkh)

      && !is_empty(datum.hashed_user_id)

  }

}```aiken│   ├── index.html│   └── migrations/             # SQL schemas

```

validator insurance_gatekeeper {

| Property | Value |

|----------|-------|  spend(datum, _redeemer, _self) {│   ├── tailwind.config.js│

| **Script Hash** | `5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e` |

| **Script Address** | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |    expect datum: InsuranceDatum



> **Note:** The smart contract is compiled and deployed on Cardano Preprod with 500 tADA locked. Script spending (unlocking) is currently disabled due to a known MeshSDK v1 limitation with Plutus V3 CBOR serialization. Payouts are processed via the treasury wallet directly — which requires the same private key, providing equivalent security.    // 1. Must be signed by treasury wallet│   └── vite.config.js├── docs/                       # Documentation



---    // 2. Datum must have non-empty hashed_user_id



## 🧠 ML Model    list.has(tx.extra_signatories, treasury_pkh)││   ├── QUICKSTART_COMPLETE.md



| Property | Value |      && !is_empty(datum.hashed_user_id)

|----------|-------|

| Algorithm | Gradient Boosting Classifier |  }├── ml-service/                 # Python ML Service│   ├── RUN_COMPLETE_SYSTEM.md

| Accuracy | **86.3%** |

| Dataset | 30,000+ simulated healthcare claims |}

| Features | Age, gender, diagnosis, admission/discharge dates, amount billed, num procedures, days admitted, insurance type, region |

| Output | Binary — `genuine` or `fraudulent` + confidence % |```│   ├── main.py                 # FastAPI endpoints│   └── FOLDER_STRUCTURE.md



The model was trained in `healthcare_fraud_final.ipynb` and exported to `ml-service/models/` as pickle files.



---### Contract Details│   ├── model_loader.py         # Model loading utilities│



## 🔗 API Reference



### ML Service (Port 8000)| Property | Value |│   ├── database.py             # PostgreSQL connection├── passwords.md                # Credentials (gitignored)



| Method | Endpoint | Description ||----------|-------|

|--------|----------|-------------|

| GET | `/` | Health check + model info || **Language** | Plutus V3 (Conway era) |│   ├── prescription_verifier.py # GPT-4o image verification└── start-all-services.sh      # One-command startup

| POST | `/predict` | Submit claim for fraud prediction |

| GET | `/users/{wallet}` | Get user by wallet (auto-registers new wallets) || **Script Hash** | `5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e` |

| PUT | `/users/{wallet}/profile` | Update user profile (name, age, gender) |

| GET | `/claims/{id}/trigger-payout` | Trigger payout for approved claim || **Script Address** | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |│   ├── export_model.py         # Re-train & export model```

| POST | `/verify-images` | Verify prescription vs receipt (GPT-4o Vision) |

| GET | `/model/info` | ML model metadata || **Treasury PKH** | `9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057` |

| GET | `/recent-activity` | Recent system activity feed |

│   ├── setup.sh                # Python venv setup script

### Blockchain Service (Port 3001)

### Current Status

| Method | Endpoint | Description |

|--------|----------|-------------|│   ├── requirements.txtSee detailed structure: [`docs/FOLDER_STRUCTURE.md`](docs/FOLDER_STRUCTURE.md)

| GET | `/health` | Health check + treasury balance |

| GET | `/api/balance` | Treasury wallet & smart contract balances |The contract is **compiled and deployed** on Cardano Preprod. Script spending (unlocking funds from the contract) is currently disabled due to a known [MeshSDK v1 limitation](https://github.com/MeshJS/mesh/issues) with Plutus V3 CBOR serialization. Payouts use the treasury wallet directly — which still requires the same private key, providing equivalent security. Smart contract spending will be enabled when MeshSDK v2 releases with full Plutus V3 support.

| POST | `/api/payout-transaction` | Submit payout transaction to Cardano |

| GET | `/api/transaction/{txHash}` | Get transaction details from Blockfrost |│   └── models/                 # Trained model artifacts (.pkl)

| GET | `/api/epoch` | Current Cardano epoch/slot info |

---

---

│---

## 🔐 Security

## 🚀 Quick Start

- **Wallet mnemonics** stored in `.env` files (gitignored — never committed)

- **Backend services** bound to `127.0.0.1` (not publicly accessible)├── server/

- **Nginx** is the only public-facing process

- **Blake2b-256 hashing** for privacy-preserving public payout records### Prerequisites

- **UFW firewall** allows only SSH (22), HTTP (80), HTTPS (443) in production

- **Treasury wallet** is the only account authorized to sign payout transactions│   └── blockchain-service/     # Node.js Blockchain Service## 🚀 Quick Start



---- **Node.js** ≥ 18 (with npm)



## 🌐 Deployment- **Python** ≥ 3.10│       ├── src/app.ts          # Express + MeshSDK + Blockfrost



The app is deployed on **DigitalOcean** at [http://178.128.212.100](http://178.128.212.100).- **Go** ≥ 1.21



| Component | Details |- **PostgreSQL** ≥ 14│       ├── tsconfig.json### Prerequisites

|-----------|---------|

| Server | DigitalOcean Droplet — Ubuntu 22.04, 2GB RAM, 1 vCPU |- **Aiken** ≥ 1.1.0 (optional, for contract compilation)

| Reverse Proxy | Nginx on port 80 |

| Services | 3 systemd services (ML, Blockchain, Automation) — auto-start on boot |- **Nginx** (for production reverse proxy)│       └── package.json

| Firewall | UFW — ports 22, 80, 443 only |

| Database | PostgreSQL 16 on localhost:5432 |

| Network | Cardano Preprod Testnet |

### 1. Clone the Repository│- Node.js 18+

**Deploy new changes:**

```bash

bash deploy.sh   # Builds frontend, syncs to server, restarts all services

``````bash├── automation-service/         # Go Automation Service- Python 3.8+



---git clone https://github.com/Yadurshan-R/HealthTrust.git



## 🛠️ Local Development Setupcd HealthTrust│   ├── blockchain.go           # Main loop + payout logic- Go 1.20+



### Prerequisites```



- Node.js ≥ 18 (with npm)│   ├── crypto.go               # Blake2b hashing- PostgreSQL 14+

- Python ≥ 3.10

- Go ≥ 1.21### 2. Set Up Environment Variables

- PostgreSQL ≥ 14

- Nginx│   ├── database.go             # DB polling



### Quick StartCreate a `.env` file in the project root:



```bash│   └── go.mod### 1. Clone & Setup

# 1. Clone the repo

git clone https://github.com/Yadurshan-R/HealthTrust.git```env

cd HealthTrust

# Database│

# 2. Set up the database

sudo -u postgres psql -c "CREATE DATABASE \"HealthTrust\";"DATABASE_URL=postgresql://user:password@localhost:5432/HealthTrust

sudo -u postgres psql -d HealthTrust -f database/schema.sql

sudo -u postgres psql -d HealthTrust -f database/seed.sql├── database/                   # Database schemas```bash

sudo -u postgres psql -d HealthTrust -f database/migrations/003_blockchain_transactions.sql

sudo -u postgres psql -d HealthTrust -f database/migrations/004_add_payout_date.sql# Blockfrost API (get from https://blockfrost.io)

sudo -u postgres psql -d HealthTrust -f database/migrations/005_add_image_verification.sql

BLOCKFROST_API_KEY=preprodXXXXXXXXXXXXXXXXXXXXXXX│   ├── schema.sql              # Core table definitionscd /home/yadu/Development/My_FYP/model_1

# 3. Create .env files (see passwords.md for credentials)



# 4. Start all services

bash start-all-services.sh# Cardano│   ├── seed.sql                # Initial data (users)



# 5. Open http://localhost in your browserCARDANO_NETWORK=preprod

```

TREASURY_ADDRESS=addr_test1q...│   └── migrations/             # Schema migrations# Apply database migrations

---

TREASURY_MNEMONIC=word1 word2 word3 ... word24

## 🔧 Tech Stack

│       ├── 003_blockchain_transactions.sqlsudo -u postgres psql HealthTrust < database/migrations/004_add_payout_date.sql

| Layer | Technology |

|-------|-----------|# OpenAI (for image verification)

| Frontend | Vue 3, Vite, TailwindCSS, MeshSDK |

| ML Service | Python 3.12, FastAPI, Uvicorn, scikit-learn 1.4.0 |OPENAI_API_KEY=sk-...│       ├── 004_add_payout_date.sql```

| Blockchain | Node.js 22, Express, MeshSDK, Blockfrost |

| Automation | Go 1.22 |```

| Smart Contracts | Aiken 1.1.19, Plutus V3 |

| Database | PostgreSQL 16 |│       └── 005_add_image_verification.sql

| Reverse Proxy | Nginx 1.24 |

| Deployment | DigitalOcean, systemd, UFW |### 3. Set Up the Database

| Network | Cardano Preprod Testnet |

| Image AI | OpenAI GPT-4o Vision |│### 2. Install Dependencies



---```bash



## 📄 License# Create the database├── aiken-contracts/            # Cardano smart contracts (Aiken)



MIT License — see [LICENSE](LICENSE) for details.psql -U postgres -c "CREATE DATABASE \"HealthTrust\";"



---│   ├── validators/```bash



## 🔗 Resources# Run schema and seed data



- [Cardano Documentation](https://docs.cardano.org)psql -U postgres -d HealthTrust -f database/schema.sql│   │   └── insurance_gatekeeper.ak# Frontend

- [MeshSDK](https://meshjs.dev)

- [Blockfrost API](https://blockfrost.io)psql -U postgres -d HealthTrust -f database/seed.sql

- [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/)

- [Aiken Smart Contracts](https://aiken-lang.org)psql -U postgres -d HealthTrust -f database/migrations/003_blockchain_transactions.sql│   └── aiken.tomlcd client && npm install

- [CardanoScan (Preprod)](https://preprod.cardanoscan.io)

psql -U postgres -d HealthTrust -f database/migrations/004_add_payout_date.sql

---

psql -U postgres -d HealthTrust -f database/migrations/005_add_image_verification.sql│

> Built by [Yadurshan R](https://github.com/Yadurshan-R) — Final Year Project 2026

```

├── treasury-wallet/            # Wallet management utilities# Blockchain Service

### 4. Install Dependencies & Start Services

│   ├── generate-wallet.jscd server/blockchain-service && npm install

```bash

# ML Service (Python)│   ├── generate-user-wallets.js

cd ml-service

python3 -m venv venv│   ├── update_user_wallets.sql# ML Service

source venv/bin/activate

pip install -r requirements.txt│   └── users/                  # Generated user wallet filescd ml-service && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt

uvicorn main:app --host 127.0.0.1 --port 8000 &

│```

# Blockchain Service (Node.js)

cd ../server/blockchain-service├── data/                       # Training data & notebooks

npm install

npx ts-node --transpile-only src/app.ts &│   ├── healthcare_claims.csv   # 20,000 simulated claims dataset### 3. Configure Environment



# Frontend (Vue 3)│   └── model_training.ipynb    # Jupyter notebook (model training)

cd ../../client

npm install│Edit `.env` file:

npm run build

├── deploy/                     # Production deployment configs```bash

# Go Automation (runs in background)

cd ../automation-service│   ├── deploy.sh               # Automated deployment scriptDATABASE_URL=postgresql://yadu:Ashokan321@localhost:5432/HealthTrust

go build -o automation && ./automation &

```│   ├── healthtrust.nginx       # Nginx config (production)BLOCKFROST_API_KEY=your_blockfrost_key_here



### 5. Using start.sh (Recommended)│   ├── healthtrust-local.nginx # Nginx config (local)TREASURY_MNEMONIC="your 24 word mnemonic"



```bash│   ├── healthtrust-ml.service  # systemd unit — ML service```

chmod +x start.sh

│   ├── healthtrust-blockchain.service  # systemd unit — Blockchain

./start.sh start    # Start all services

./start.sh stop     # Stop all services│   └── healthtrust-go.service  # systemd unit — Go automationSee all credentials in `passwords.md`

./start.sh status   # Check what's running

./start.sh restart  # Restart everything│

```

├── start.sh                    # 🚀 One-command startup script### 4. Start All Services

---

├── .env                        # Environment variables (gitignored)

## 🧠 ML Model

├── .gitignore```bash

The fraud detection model is a **Gradient Boosting Classifier** trained on 30,000+ simulated healthcare claims.

└── README.md                   # ← You are here./start-all-services.sh

### Model Performance

``````

| Metric | Score |

|--------|-------|

| **Accuracy** | 86.3% |

| **Precision** | 86% |---Or manually in separate terminals:

| **Recall** | 86% |

| **F1-Score** | 86% |```bash



### Features Used## 🚀 Quick Start# Terminal 1: ML Service



The model analyzes these claim attributes:cd ml-service && source venv/bin/activate && python app.py

- `age`, `gender`, `income` — Patient demographics

- `amount_billed` — Claim amount### Prerequisites

- `num_procedures`, `num_diagnoses` — Medical complexity

- `days_admitted` — Hospital stay duration# Terminal 2: Blockchain Service

- `insurance_type`, `region` — Policy information

| Requirement | Version |cd server/blockchain-service && npm run dev

### Training

|-------------|---------|

The model was trained in `data/model_training.ipynb` and exported to `ml-service/models/` as a pickle file. To retrain:

| Node.js | 22+ |# Terminal 3: Go Automation

```bash

cd ml-service| Python | 3.10+ |cd automation-service && go run *.go

python export_model.py

```| Go | 1.21+ |



---| PostgreSQL | 16+ |# Terminal 4: Frontend



## ⛓️ Blockchain Integration| Nginx | 1.18+ |cd client && npm run dev



### Treasury Wallet```



The treasury wallet is a Cardano Preprod testnet wallet managed by MeshSDK. It holds the funds for insurance payouts.### 1. Setup Database



- **Network**: Cardano Preprod Testnet### 5. Access the App

- **SDK**: MeshSDK v1.8.14

- **Provider**: Blockfrost API```bash



### Transaction Metadata# Start PostgreSQLOpen: **http://localhost:5173**



Every payout transaction includes CIP-20 metadata (label 674) with:sudo systemctl start postgresql



```json---

{

  "msg": ["HealthTrust Insurance Payout"],# Create database & user

  "claim_id": 100,

  "user_id": 1,sudo -u postgres psql <<EOF## 📚 Documentation

  "amount_ada": 5.0,

  "ml_status": "approved",CREATE DATABASE "HealthTrust";

  "claim_type": "consultation",

  "patient": "Alice Johnson",CREATE USER yadu WITH PASSWORD 'your_password';| Document | Description |

  "smart_contract": "addr_test1wztz8zu9yyw372...",

  "approved_at": "2026-02-22T12:00:00.000Z",GRANT ALL PRIVILEGES ON DATABASE "HealthTrust" TO yadu;|----------|-------------|

  "network": "preprod"

}\c "HealthTrust"| [Quick Start](docs/QUICKSTART_COMPLETE.md) | Fast setup guide |

```

GRANT ALL ON SCHEMA public TO yadu;| [Complete Guide](docs/RUN_COMPLETE_SYSTEM.md) | Detailed instructions |

### API Endpoints

EOF| [Folder Structure](docs/FOLDER_STRUCTURE.md) | Project organization |

#### ML Service (Port 8000)

| [Implementation Summary](docs/IMPLEMENTATION_SUMMARY.md) | What was built |

| Method | Endpoint | Description |

|--------|----------|-------------|# Load schema, migrations, and seed data| `passwords.md` | All credentials (local only) |

| POST | `/predict` | Run fraud prediction on a claim |

| GET | `/users/:wallet` | Get user by wallet address |sudo -u postgres psql -d HealthTrust -f database/schema.sql

| GET | `/claims/:id/trigger-payout` | Trigger payout for approved claim |

| POST | `/verify-images` | Verify prescription vs receipt (GPT-4o) |sudo -u postgres psql -d HealthTrust -f database/migrations/003_blockchain_transactions.sql---

| GET | `/model/info` | ML model details |

| GET | `/recent-activity` | Recent system activity |sudo -u postgres psql -d HealthTrust -f database/migrations/004_add_payout_date.sql



#### Blockchain Service (Port 3001)sudo -u postgres psql -d HealthTrust -f database/migrations/005_add_image_verification.sql## 🧪 Testing the Flow



| Method | Endpoint | Description |sudo -u postgres psql -d HealthTrust -f database/seed.sql

|--------|----------|-------------|

| GET | `/health` | Service health + wallet/script balances |```### 1. Submit a Claim

| GET | `/api/balance` | Detailed wallet + smart contract balance |

| GET | `/api/epoch` | Current Cardano epoch/slot info |

| POST | `/api/payout-transaction` | Submit a payout to recipient |

| GET | `/api/transaction/:txHash` | Get transaction details from Blockfrost |### 2. Install Dependencies- Open http://localhost:5173



---- Fill in patient details



## 🔐 Security```bash- Amount: 100 tADA



- **Private keys** are stored in `.env` (never committed to git)# Frontend- Submit

- **Blake2b-256** hashing used for user identity on public blockchain

- **Treasury wallet** is the only account that can authorize payoutscd client && npm install && cd ..

- **Aiken validator** enforces treasury signature requirement on-chain

- **All services** bind to `127.0.0.1` — only accessible through Nginx### 2. ML Prediction



---# Blockchain Service



## 🛠️ Tech Stackcd server/blockchain-service && npm install && cd ../..- System automatically predicts: `genuine` or `fake`



| Layer | Technology |- Confidence score displayed

|-------|-----------|

| Frontend | Vue 3, Vite, TailwindCSS, MeshSDK |# ML Service

| ML Service | Python 3.10, FastAPI, scikit-learn, Uvicorn |

| Blockchain | Node.js, Express, MeshSDK, Blockfrost |cd ml-service && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && deactivate && cd ..### 3. Trigger Payout

| Smart Contract | Aiken 1.1.19, Plutus V3 |

| Automation | Go 1.25 |```

| Database | PostgreSQL 18 |

| Reverse Proxy | Nginx |- If genuine → Click "Claim Amount"

| Blockchain | Cardano Preprod Testnet |

### 3. Configure Environment- Wait 60 seconds for automation

---



## 📄 License

Create `.env` in the project root:### 4. Verify on Blockchain

MIT License — See [LICENSE](LICENSE) for details.

```env

---

DATABASE_URL=postgresql://yadu:your_password@localhost:5432/HealthTrust?sslmode=disable- Transaction hash appears

> Built by [Yadurshan R](https://github.com/Yadurshan-R) — Final Year Project 2026

BLOCKFROST_API_KEY=your_blockfrost_api_key- Click to view on CardanoScan

TREASURY_ADDRESS=your_treasury_address- Check metadata label 674

TREASURY_MNEMONIC=your 24 word treasury mnemonic

```---



Create `ml-service/.env`:## 🔧 Technology Stack

```env

DATABASE_URL=postgresql://yadu:your_password@localhost:5432/HealthTrust### Frontend

OPENAI_API_KEY=your_openai_key- Vue 3 (Composition API)

```- TypeScript

- Vite

Create `server/blockchain-service/.env`:- MeshSDK (Cardano wallet)

```env

CARDANO_NETWORK=preprod### Backend

BLOCKFROST_API_KEY=your_blockfrost_api_key- **ML Service:** Python + Flask + Scikit-learn

TREASURY_MNEMONIC=your 24 word treasury mnemonic- **Blockchain:** Node.js + MeshSDK + Blockfrost

TREASURY_ADDRESS=your_treasury_address- **Automation:** Go (polling & processing)

PORT=3001

```### Blockchain

- Cardano Preprod Testnet

### 4. Start All Services- MeshSDK for transactions

- Blockfrost API for data

```bash- Metadata label 674 for claim data

bash start.sh          # Start all + ngrok public link

bash start.sh local    # Start all, localhost only### Database

bash start.sh status   # Check status of all services- PostgreSQL 14+

bash start.sh stop     # Stop everything- Tables: users, claims, blockchain_transactions

bash start.sh restart  # Restart all services

```---



### 5. Access the App## 📊 ML Model Performance



| Endpoint | URL |- **Algorithm:** Gradient Boosting Classifier

|----------|-----|- **Accuracy:** 86.3%

| Frontend | http://localhost |- **Features:** Age, diagnosis, amount, medical history

| ML API | http://localhost/api/ |- **Output:** Binary classification (genuine/fake)

| Blockchain API | http://localhost/service/health |

---

---

## 🔒 Security & Privacy

## 🧪 Testing the Flow

- **User Privacy:** Blake2b hashing for public records

### Step 1 — Verify Services- **Treasury Security:** Mnemonic stored in `.env` (gitignored)

- **Database:** Encrypted connections

```bash- **Testnet Only:** All testing on Cardano Preprod

bash start.sh status

# All 5 services should show RUNNING (Nginx, ML, Blockchain, Go, PostgreSQL)---

```

## 🎓 Academic Context

### Step 2 — Health Checks

**Final Year Project (FYP)**  

```bash**Topic:** AI-Powered Healthcare Insurance Fraud Detection on Blockchain

curl http://localhost/api/                # ML service health

curl http://localhost/service/health      # Blockchain service health**Key Contributions:**

```1. Integration of ML with blockchain for insurance

2. Automated payout system with fraud prevention

### Step 3 — Submit a Claim3. Privacy-preserving public ledger

4. Real-world Cardano testnet deployment

1. Open **http://localhost** in your browser

2. Connect a Cardano wallet (Nami, Eternl, or Lace — Preprod testnet)---

3. Fill in the 3-step claim form (Hospital Stay → Diagnosis → Documents)

4. Submit — the ML model predicts `genuine` or `fraudulent`## 🚧 Future Enhancements



### Step 4 — Payout- [ ] Deploy to Cardano mainnet

- [ ] Implement Aiken smart contracts

- If the claim is genuine → click **"Claim Amount"**- [ ] Add batch claim processing

- The Go automation service processes payouts every 60 seconds- [ ] Real-time confirmation tracking in UI

- A Cardano transaction is submitted to Preprod testnet- [ ] Multi-wallet support (Lace, Eternl, Nami)

- Transaction hash appears — click to view on [CardanoScan](https://preprod.cardanoscan.io)

---

---

## 🤝 Contributing

## 📊 ML Model

This is an academic project. For questions or collaboration:

| Property | Value |

|----------|-------|1. Review documentation in `docs/`

| Algorithm | Gradient Boosting Classifier |2. Check `passwords.md` for credentials

| Accuracy | 86.3% |3. Follow folder structure in `FOLDER_STRUCTURE.md`

| Dataset | 20,000 simulated healthcare claims |

| Features | Age, diagnosis, admission/discharge dates, amount billed |---

| Output | Binary — `genuine` or `fraudulent` |

## 📄 License

**Training notebook:** [`data/model_training.ipynb`](data/model_training.ipynb)

MIT License - see [LICENSE](LICENSE) file

**Re-export model:**

```bash---

cd ml-service && source venv/bin/activate && python export_model.py

```## 🔗 Resources



---- [Cardano Docs](https://docs.cardano.org)

- [MeshSDK](https://meshjs.dev)

## 🔗 API Reference- [Blockfrost](https://blockfrost.io)

- [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/)

### ML Service (Python — port 8000)

---

| Method | Endpoint | Description |

|--------|----------|-------------|## 💡 Quick Commands

| GET | `/` | Health check + model info |

| POST | `/predict` | Submit claim for fraud prediction |```bash

| GET | `/users/:wallet` | Get user by wallet address |# Start everything

| POST | `/claims/:id/trigger-payout` | Trigger payout for approved claim |./start-all-services.sh

| POST | `/verify-images` | Verify prescription vs receipt (GPT-4o) |

| GET | `/model/info` | Model metadata |# Check services

| GET | `/recent-activity` | Recent claims activity |curl http://localhost:8000/health     # ML

curl http://localhost:3001/health     # Blockchain

### Blockchain Service (Node.js — port 3001)curl http://localhost:5173            # Frontend



| Method | Endpoint | Description |# Check treasury balance

|--------|----------|-------------|curl http://localhost:3001/api/balance

| GET | `/health` | Health check + treasury balance |

| GET | `/api/balance` | Treasury wallet balance |# View database

| POST | `/api/payout-transaction` | Submit payout to Cardano |PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust

| GET | `/api/transaction/:txHash` | Get transaction details |

# Stop all services

---lsof -ti:8000,3001,5173 | xargs kill -9

```

## 🗄️ Database Reference

---

**Tables:** `users`, `claims`, `blockchain_transactions`, `public_payouts`

**🎉 Your Healthcare Insurance dApp is ready!**

```bash

# Connect to databaseFor detailed setup, see: [`docs/RUN_COMPLETE_SYSTEM.md`](docs/RUN_COMPLETE_SYSTEM.md)

sudo -u postgres psql HealthTrust

# Useful queries
\dt                                    -- List all tables
\d claims                              -- Describe claims table

SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM claims;

-- Recent claims
SELECT id, amount_billed, ml_status, payout_status
FROM claims ORDER BY created_at DESC LIMIT 10;

-- Blockchain transactions
SELECT tx_hash, status, confirmations
FROM blockchain_transactions ORDER BY created_at DESC LIMIT 10;

-- Claims by status
SELECT ml_status, payout_status, COUNT(*) as count
FROM claims GROUP BY ml_status, payout_status;
```

---

## 🌐 Deployment

### Local Development (with ngrok)

```bash
bash start.sh           # Starts all services + ngrok tunnel
# Public URL shown in terminal output
```

### Production Server

See `deploy/` directory for Nginx configs, systemd units, and deployment script.

**Summary:**
1. Copy project to server via `rsync` (exclude `node_modules`, `venv`, `.git`)
2. Install system packages (Node 22, Python 3.10+, Go 1.21+, Nginx, PostgreSQL)
3. Setup database, create `.env` files
4. Build frontend: `cd client && npm run build`
5. Setup Python venv + install requirements
6. Install Node.js dependencies
7. Build Go binary: `cd automation-service && go build -o automation-service *.go`
8. Install systemd services from `deploy/`
9. Configure Nginx + SSL (Let's Encrypt via certbot)
10. Enable UFW firewall (ports 22, 80, 443 only)

**Manage services:**
```bash
sudo systemctl start healthtrust-ml healthtrust-blockchain healthtrust-go
sudo systemctl status healthtrust-ml healthtrust-blockchain healthtrust-go
sudo journalctl -u healthtrust-ml -f    # View logs
```

---

## 🔒 Security

- **Wallet mnemonics** stored in `.env` (gitignored, never committed)
- **Backend services** bound to `127.0.0.1` (not publicly accessible)
- **Nginx** is the only public-facing process
- **Blake2b hashing** for privacy-preserving public payout records
- **UFW firewall** allows only SSH, HTTP, HTTPS in production
- **CORS** should be restricted in production

---

## 🔧 Technology Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Vue 3, Vite, TailwindCSS, MeshSDK |
| ML Service | Python 3.10, FastAPI, Uvicorn, Scikit-learn |
| Blockchain | Node.js 22, Express, MeshSDK, Blockfrost |
| Automation | Go 1.25 |
| Smart Contracts | Aiken (Cardano) |
| Database | PostgreSQL 18 |
| Reverse Proxy | Nginx |
| Network | Cardano Preprod Testnet |

---

## 📄 License

MIT License — see [LICENSE](LICENSE) file

---

## 🔗 Resources

- [Cardano Documentation](https://docs.cardano.org)
- [MeshSDK](https://meshjs.dev)
- [Blockfrost API](https://blockfrost.io)
- [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/)
- [Aiken Smart Contracts](https://aiken-lang.org)
