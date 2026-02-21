# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 HealthTrust — AI-Powered Insurance Fraud Detection on Cardano# 🏥 Healthcare Insurance Fraud Detection dApp



**Final Year Project** — Decentralized Healthcare Insurance Claims Processing



[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)**AI-Powered Insurance Claims Processing on Cardano Blockchain**

[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)

[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)[![ML Model](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)

[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)[![Cardano](https://img.shields.io/badge/Cardano-Preprod-blue)](https://preprod.cardanoscan.io)

---

[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)[![ML Model](https://img.shields.io/badge/ML%20Accuracy-86.3%25-green)](ml-service/)

## 🎯 Overview

[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

HealthTrust is a decentralized insurance application that combines **AI fraud detection** with **Cardano blockchain** to automate claim verification and payouts. The system ensures transparency, immutability, and privacy.

A decentralized insurance application that combines **AI fraud detection** with **Cardano blockchain** to automate claim verification and payouts. The system ensures transparency, immutability, and privacy while maintaining high accuracy in fraud detection.

### How It Works

---

```

Patient submits claim → ML model checks for fraud (86.3% accuracy)> **Final Year Project** — AI-Powered Healthcare Insurance Fraud Detection on Blockchain

    → If approved → Go automation triggers blockchain payout

        → Treasury wallet sends ADA to patient's Cardano wallet## 🎯 Project Overview

            → On-chain metadata records the claim details permanently

```---



### Key FeaturesA decentralized insurance application that uses **AI fraud detection** combined with **Cardano blockchain** to automate claim verification and payouts. The system ensures transparency, immutability, and privacy while maintaining high accuracy in fraud detection.



- 🤖 **AI Fraud Detection** — Gradient Boosting classifier trained on 30,000+ claims## ✨ Key Features

- ⛓️ **Blockchain Payouts** — Automated on-chain ADA transactions via MeshSDK

- 📜 **Aiken Smart Contract** — Plutus V3 Insurance Gatekeeper validator (compiled & deployed)### Key Features

- 🔒 **Privacy Preserved** — Blake2b-256 hashing for user identity on public ledger

- 📋 **On-Chain Records** — Every payout recorded with CIP-20 metadata (label 674)- **AI Fraud Detection** — 86.3% accuracy using Gradient Boosting classifier

- ⚡ **60-Second Automation** — Go service continuously polls and processes approved claims

- 🖼️ **Image Verification** — GPT-4o Vision compares prescriptions against pharmacy receipts- **Blockchain Payouts** — Automated on-chain transactions via MeshSDK on Cardano Preprod- ✅ **AI Fraud Detection** - 86.3% accuracy using Gradient Boosting



---- **Image Verification** — GPT-4o Vision compares prescriptions against pharmacy receipts- ✅ **Blockchain Payouts** - Automated on-chain transactions via MeshSDK



## 🏗️ Architecture- **Privacy Preserved** — Blake2b hashing for public payout records- ✅ **Privacy Preserved** - Blake2b hashing for user data



```- **Transparent Records** — All payouts immutably recorded on-chain (metadata label 674)- ✅ **Transparent Records** - All payouts recorded on Cardano Preprod

┌────────────────────────────────────────────────────────────┐

│                     Nginx (port 80)                        │- **60-Second Automation** — Go service polls and processes approved payouts continuously- ✅ **Real-time Processing** - 60-second automation polling

│   /  → Vue SPA     /api/ → Python :8000                   │

│                     /service/ → Node.js :3001              │

└──────┬──────────────────┬──────────────────┬───────────────┘

       │                  │                  │------

┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼───────────────┐

│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK   │

│  TailwindCSS│   │  ML Service │   │  Blockchain Service  │

│  MeshSDK    │   │  Port 8000  │   │  Port 3001           │## 🏗️ Architecture## 🏗️ Architecture

└─────────────┘   └──────┬──────┘   └──────┬───────────────┘

                         │                 │

                  ┌──────▼─────────────────▼────┐

                  │     PostgreSQL (5432)        │``````

                  │     Database: HealthTrust    │

                  └──────────────┬───────────────┘┌──────────────────────────────────────────────────────────────────┐┌─────────────────────────────────────────────────────────┐

                                 │

                  ┌──────────────▼───────────────┐│                        Nginx (port 80)                           ││                Vue 3 Frontend (client/)                 │

                  │   Go Automation Service      │

                  │   Polls DB → triggers payouts││  /  → Vue SPA    /api/ → Python :8000    /service/ → Node :3001  ││          User submits claims, views results             │

                  │   every 60 seconds           │

                  └──────────────────────────────┘└──────────┬───────────────┬───────────────────┬───────────────────┘└──────────┬──────────────────────────────────────────────┘

```

           │               │                   │           │

---

    ┌──────▼──────┐ ┌──────▼──────┐  ┌─────────▼──────────┐           ├─────────────┬──────────────┬─────────────────┐

## 📁 Project Structure

    │  Vue 3 +    │ │  FastAPI    │  │  Express + MeshSDK  │           ▼             ▼              ▼                 ▼

| Service | Language | Framework | Port | Role |

|---------|----------|-----------|------|------|    │  TailwindCSS│ │  ML Service │  │  Blockchain Service │    ┌──────────┐  ┌───────────┐  ┌───────────┐   ┌────────────┐

| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | — (Nginx) | User interface, wallet connection |

| ML Service | Python 3.10 | FastAPI + Uvicorn | 8000 | Fraud prediction, image verification, CRUD |    │  MeshSDK    │ │  Port 8000  │  │  Port 3001          │    │ML Service│  │Go Service │  │Blockchain │   │ PostgreSQL │

| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 | Cardano transaction building & submission |

| Automation | Go 1.25 | stdlib | — | Polls DB, triggers payouts via blockchain service |    └─────────────┘ └──────┬──────┘  └─────────┬───────────┘    │(Python)  │  │(Automation)│  │(Node.js)  │   │ Database   │

| Smart Contract | Aiken 1.1.19 | Plutus V3 | — | On-chain Insurance Gatekeeper validator |

| Database | — | PostgreSQL 18 | 5432 | Users, claims, transactions, payouts |                           │                   │    │Port 8000 │  │Background │  │Port 3001  │   │ Port 5432  │



```                    ┌──────▼───────────────────▼────┐    └──────────┘  └───────────┘  └─────┬─────┘   └────────────┘

healthtrust/

├── client/                     # Vue 3 Frontend (SPA)                    │       PostgreSQL (5432)        │                                        │

│   ├── src/

│   │   ├── components/         # ClaimForm, ClaimsList, NavBar, etc.                    │       Database: HealthTrust    │                                        ▼

│   │   ├── composables/        # useToast

│   │   ├── api.js              # API client                    └──────────────┬────────────────┘                              ┌──────────────────┐

│   │   ├── App.vue             # Root component

│   │   └── main.js             # Entry point                                   │                              │ Cardano Preprod  │

│   ├── tailwind.config.js

│   └── vite.config.js                    ┌──────────────▼────────────────┐                              │  Testnet         │

│

├── ml-service/                 # Python ML Service                    │    Go Automation Service       │                              └──────────────────┘

│   ├── main.py                 # FastAPI endpoints

│   ├── model_loader.py         # Model loading utilities                    │    Polls DB → triggers payouts │```

│   ├── database.py             # PostgreSQL connection

│   ├── prescription_verifier.py # GPT-4o image verification                    │    every 60 seconds            │

│   ├── export_model.py         # Re-train & export model

│   ├── requirements.txt                    └───────────────────────────────┘---

│   └── models/                 # Trained model artifacts (.pkl)

│```

├── server/

│   └── blockchain-service/     # Node.js Blockchain Service## 📁 Project Structure

│       ├── src/app.ts          # Express + MeshSDK + Blockfrost

│       ├── tsconfig.json| Service | Language | Framework | Port | Role |

│       └── package.json

│|---------|----------|-----------|------|------|```

├── automation-service/         # Go Automation Service

│   ├── blockchain.go           # Payout logic| Frontend | Vue 3 | Vite + TailwindCSS + MeshSDK | — (Nginx) | User interface, wallet connection |model_1/

│   ├── crypto.go               # Blake2b hashing

│   ├── database.go             # DB polling| ML Service | Python 3.10 | FastAPI + Uvicorn | 8000 | Fraud prediction, CRUD, image verification |├── client/                      # Vue 3 Frontend

│   └── go.mod

│| Blockchain Service | TypeScript | Express + MeshSDK + Blockfrost | 3001 | Cardano transaction building & submission |│   ├── src/

├── aiken-contracts/            # Aiken Smart Contract (Plutus V3)

│   ├── validators/| Automation | Go 1.25 | stdlib | — | Polls DB, triggers payouts via Blockchain Service |│   │   ├── components/         # Vue components

│   │   └── insurance_gatekeeper.ak   # On-chain validator

│   ├── aiken.toml| Database | — | PostgreSQL 18 | 5432 | Users, claims, transactions, payouts |│   │   ├── views/              # Page views

│   └── build/                  # Compiled plutus.json

││   │   └── App.vue             # Root component

├── database/                   # Database schemas

│   ├── schema.sql              # Core tables---│   └── package.json

│   ├── seed.sql                # Initial data (3 users with wallets)

│   └── migrations/             # Schema updates│

│

├── treasury-wallet/            # Cardano wallet management## 📁 Project Structure├── server/

│   ├── generate-wallet.js

│   ├── generate-user-wallets.js│   ├── blockchain-service/     # Node.js + MeshSDK

│   └── users/                  # User wallet files

│```│   │   ├── src/app.ts         # Cardano integration

├── data/                       # Training data & notebook

│   ├── healthcare_claims.csvhealthtrust/│   │   └── package.json

│   └── model_training.ipynb

│├── client/                     # Vue 3 Frontend (SPA)│   └── go-api/                 # Go API (future)

├── start.sh                    # Start/stop all services

├── .env                        # Environment variables│   ├── src/│

└── .gitignore

```│   │   ├── components/         # Vue components (ClaimForm, ClaimsList, NavBar, etc.)├── ml-service/                 # Python ML Service



---│   │   ├── composables/        # Composable hooks (useToast)│   ├── app.py                 # Flask API



## 📜 Aiken Smart Contract│   │   ├── api.js              # API client│   └── voting_classifier_model.pkl



The **Insurance Gatekeeper** is a Plutus V3 validator compiled with Aiken v1.1.19. It enforces on-chain rules for insurance payouts.│   │   ├── App.vue             # Root component│



### Validator Logic│   │   └── main.js             # Entry point├── database/



```aiken│   ├── index.html│   └── migrations/             # SQL schemas

validator insurance_gatekeeper {

  spend(datum, _redeemer, _self) {│   ├── tailwind.config.js│

    expect datum: InsuranceDatum

    // 1. Must be signed by treasury wallet│   └── vite.config.js├── docs/                       # Documentation

    // 2. Datum must have non-empty hashed_user_id

    list.has(tx.extra_signatories, treasury_pkh)││   ├── QUICKSTART_COMPLETE.md

      && !is_empty(datum.hashed_user_id)

  }├── ml-service/                 # Python ML Service│   ├── RUN_COMPLETE_SYSTEM.md

}

```│   ├── main.py                 # FastAPI endpoints│   └── FOLDER_STRUCTURE.md



### Contract Details│   ├── model_loader.py         # Model loading utilities│



| Property | Value |│   ├── database.py             # PostgreSQL connection├── passwords.md                # Credentials (gitignored)

|----------|-------|

| **Language** | Plutus V3 (Conway era) |│   ├── prescription_verifier.py # GPT-4o image verification└── start-all-services.sh      # One-command startup

| **Script Hash** | `5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e` |

| **Script Address** | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |│   ├── export_model.py         # Re-train & export model```

| **Treasury PKH** | `9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057` |

│   ├── setup.sh                # Python venv setup script

### Current Status

│   ├── requirements.txtSee detailed structure: [`docs/FOLDER_STRUCTURE.md`](docs/FOLDER_STRUCTURE.md)

The contract is **compiled and deployed** on Cardano Preprod. Script spending (unlocking funds from the contract) is currently disabled due to a known [MeshSDK v1 limitation](https://github.com/MeshJS/mesh/issues) with Plutus V3 CBOR serialization. Payouts use the treasury wallet directly — which still requires the same private key, providing equivalent security. Smart contract spending will be enabled when MeshSDK v2 releases with full Plutus V3 support.

│   └── models/                 # Trained model artifacts (.pkl)

---

│---

## 🚀 Quick Start

├── server/

### Prerequisites

│   └── blockchain-service/     # Node.js Blockchain Service## 🚀 Quick Start

- **Node.js** ≥ 18 (with npm)

- **Python** ≥ 3.10│       ├── src/app.ts          # Express + MeshSDK + Blockfrost

- **Go** ≥ 1.21

- **PostgreSQL** ≥ 14│       ├── tsconfig.json### Prerequisites

- **Aiken** ≥ 1.1.0 (optional, for contract compilation)

- **Nginx** (for production reverse proxy)│       └── package.json



### 1. Clone the Repository│- Node.js 18+



```bash├── automation-service/         # Go Automation Service- Python 3.8+

git clone https://github.com/Yadurshan-R/HealthTrust.git

cd HealthTrust│   ├── blockchain.go           # Main loop + payout logic- Go 1.20+

```

│   ├── crypto.go               # Blake2b hashing- PostgreSQL 14+

### 2. Set Up Environment Variables

│   ├── database.go             # DB polling

Create a `.env` file in the project root:

│   └── go.mod### 1. Clone & Setup

```env

# Database│

DATABASE_URL=postgresql://user:password@localhost:5432/HealthTrust

├── database/                   # Database schemas```bash

# Blockfrost API (get from https://blockfrost.io)

BLOCKFROST_API_KEY=preprodXXXXXXXXXXXXXXXXXXXXXXX│   ├── schema.sql              # Core table definitionscd /home/yadu/Development/My_FYP/model_1



# Cardano│   ├── seed.sql                # Initial data (users)

CARDANO_NETWORK=preprod

TREASURY_ADDRESS=addr_test1q...│   └── migrations/             # Schema migrations# Apply database migrations

TREASURY_MNEMONIC=word1 word2 word3 ... word24

│       ├── 003_blockchain_transactions.sqlsudo -u postgres psql HealthTrust < database/migrations/004_add_payout_date.sql

# OpenAI (for image verification)

OPENAI_API_KEY=sk-...│       ├── 004_add_payout_date.sql```

```

│       └── 005_add_image_verification.sql

### 3. Set Up the Database

│### 2. Install Dependencies

```bash

# Create the database├── aiken-contracts/            # Cardano smart contracts (Aiken)

psql -U postgres -c "CREATE DATABASE \"HealthTrust\";"

│   ├── validators/```bash

# Run schema and seed data

psql -U postgres -d HealthTrust -f database/schema.sql│   │   └── insurance_gatekeeper.ak# Frontend

psql -U postgres -d HealthTrust -f database/seed.sql

psql -U postgres -d HealthTrust -f database/migrations/003_blockchain_transactions.sql│   └── aiken.tomlcd client && npm install

psql -U postgres -d HealthTrust -f database/migrations/004_add_payout_date.sql

psql -U postgres -d HealthTrust -f database/migrations/005_add_image_verification.sql│

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
