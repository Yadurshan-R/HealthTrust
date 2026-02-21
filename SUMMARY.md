# 📖 HealthTrust — Complete Project Summary

> **Final Year Project** by Yadurshan R
> AI-Powered Healthcare Insurance Fraud Detection on Cardano Blockchain

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [System Architecture](#2-system-architecture)
3. [Technology Stack](#3-technology-stack)
4. [Data Flow — End to End](#4-data-flow--end-to-end)
5. [Directory Structure & File-by-File Breakdown](#5-directory-structure--file-by-file-breakdown)
   - [Root Files](#51-root-files)
   - [Frontend — `client/`](#52-frontend--client)
   - [ML Service — `ml-service/`](#53-ml-service--ml-service)
   - [Blockchain Service — `server/blockchain-service/`](#54-blockchain-service--serverblockchain-service)
   - [Automation Service — `automation-service/`](#55-automation-service--automation-service)
   - [Smart Contract — `aiken-contracts/`](#56-smart-contract--aiken-contracts)
   - [Database — `database/`](#57-database--database)
   - [Treasury Wallet — `treasury-wallet/`](#58-treasury-wallet--treasury-wallet)
   - [Deployment — `deploy/`](#59-deployment--deploy)
   - [Data — `data/`](#510-data--data)
6. [Database Schema](#6-database-schema)
7. [API Reference](#7-api-reference)
8. [Smart Contract Details](#8-smart-contract-details)
9. [ML Model Details](#9-ml-model-details)
10. [Security & Privacy](#10-security--privacy)
11. [Deployment Architecture](#11-deployment-architecture)
12. [Known Limitations](#12-known-limitations)

---

## 1. Project Overview

HealthTrust is a **decentralized healthcare insurance application** that combines three core technologies:

1. **Machine Learning** — A Gradient Boosting classifier trained on 20,000 simulated healthcare claims detects fraudulent insurance claims with **86.3% accuracy**.
2. **Computer Vision** — GPT-4o Vision API compares doctor's prescriptions against pharmacy receipts to verify document authenticity.
3. **Cardano Blockchain** — All approved payouts are executed as on-chain ADA transactions on the Cardano Preprod testnet, with claim metadata immutably recorded using CIP-20 (label 674).

### How It Works (High Level)

```
1. Patient connects Cardano wallet (Nami/Eternl/Lace) to the Vue.js frontend
2. Patient submits an insurance claim (diagnosis, amount, optional documents)
3. ML model predicts: genuine or fraudulent (with confidence score)
4. If documents uploaded: GPT-4o Vision verifies prescription vs receipt
5. Combined score = (ML confidence + Image verification) / 2
6. If combined score ≥ 80% → claim approved
7. Patient clicks "Claim Amount" → payout_status set to 'trigger'
8. Go automation service (polling every 60s) picks up triggered claims
9. Go calls Node.js blockchain service → builds & signs Cardano transaction
10. Treasury wallet sends ADA to patient's wallet with on-chain metadata
11. Transaction hash stored in database, visible on CardanoScan explorer
```

---

## 2. System Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                       Nginx (port 80)                        │
│                                                              │
│   /         →  Vue.js SPA (static files from client/dist/)   │
│   /api/*    →  Python FastAPI ML Service (127.0.0.1:8000)    │
│   /service/* → Node.js Blockchain Service (127.0.0.1:3001)   │
└──────┬──────────────────┬──────────────────┬─────────────────┘
       │                  │                  │
┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼────────────────┐
│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK    │
│  TailwindCSS│   │  + Uvicorn  │   │  + Blockfrost        │
│  + MeshSDK  │   │  Port 8000  │   │  Port 3001           │
└─────────────┘   └──────┬──────┘   └──────┬────────────────┘
                         │                 │
                  ┌──────▼─────────────────▼────┐
                  │       PostgreSQL (5432)      │
                  │       Database: HealthTrust  │
                  └──────────────┬───────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │    Go Automation Service      │
                  │    Polls DB every 60 seconds  │
                  │    Calls blockchain service   │
                  └──────────────────────────────┘
                                 │
                  ┌──────────────▼───────────────┐
                  │    Cardano Preprod Testnet    │
                  │    (via Blockfrost API)       │
                  └──────────────────────────────┘
```

### Service Communication

| From | To | Method | Purpose |
|------|----|--------|---------|
| Browser | Nginx :80 | HTTPS (ngrok) | All requests |
| Nginx | Python :8000 | HTTP reverse proxy | ML predictions, user CRUD |
| Nginx | Node.js :3001 | HTTP reverse proxy | Blockchain operations |
| Frontend | Cardano | CIP-30 wallet API | Wallet connection (browser extension) |
| Go Service | PostgreSQL :5432 | TCP (SQL) | Poll for triggered claims |
| Go Service | Node.js :3001 | HTTP POST | Submit payout transactions |
| Node.js | Blockfrost API | HTTPS | Build & submit Cardano transactions |
| Python | OpenAI API | HTTPS | GPT-4o Vision for image verification |

---

## 3. Technology Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **Frontend** | Vue 3 | 3.5.24 | Reactive SPA framework |
| | Vite | 7.2.4 | Build tool & dev server |
| | TailwindCSS | 3.4.19 | Utility-first CSS |
| | MeshSDK | 1.9.0-beta | Cardano wallet integration (CIP-30) |
| | Heroicons | 2.2.0 | SVG icon library |
| | Axios | 1.13.2 | HTTP client |
| | vue3-toastify | 0.2.8 | Toast notifications |
| | vite-plugin-node-polyfills | 0.25.0 | Node.js polyfills for MeshSDK |
| **ML Service** | Python | 3.10 | Runtime |
| | FastAPI | 0.109.0 | REST API framework |
| | Uvicorn | 0.27.0 | ASGI server |
| | scikit-learn | 1.6.1 | ML model (Gradient Boosting) |
| | SQLAlchemy | 2.0.25 | ORM for PostgreSQL |
| | OpenAI | 1.59.7 | GPT-4o Vision API |
| | Pandas | 2.2.3 | Data processing |
| | Pydantic | 2.5.3 | Request/response validation |
| **Blockchain** | Node.js | 22 | Runtime |
| | Express | 4.18.2 | HTTP server |
| | MeshSDK | 1.7.8+ | Cardano transaction building |
| | Blockfrost | (via fetch) | Cardano node gateway |
| | TypeScript | 5.3.3 | Type-safe development |
| | ts-node | 10.9.2 | TypeScript execution |
| **Automation** | Go | 1.21+ | Runtime |
| | lib/pq | 1.10.9 | PostgreSQL driver |
| | golang.org/x/crypto | 0.18.0 | Blake2b-256 hashing |
| | godotenv | 1.5.1 | Environment variable loading |
| **Smart Contract** | Aiken | 1.1.19 | Cardano smart contract language |
| | Plutus V3 | Conway era | On-chain validator |
| | aiken-lang/stdlib | 3.0.0 | Standard library |
| **Database** | PostgreSQL | 18 | Relational database |
| **Reverse Proxy** | Nginx | 1.18 | Load balancing, static files, rate limiting |
| **Tunnel** | ngrok | latest | HTTPS tunnel for public access |

---

## 4. Data Flow — End to End

### Flow 1: Wallet Connection
```
User opens app → Clicks "Connect Wallet"
  → WalletSelector.vue detects installed Cardano wallets (Nami, Eternl, Lace)
  → User picks wallet → CIP-30 API call: window.cardano[wallet].enable()
  → Gets wallet address (addr_test1...)
  → Frontend calls: GET /api/users/{wallet_address}
  → Python queries PostgreSQL → returns user profile + all claims
  → Frontend stores userData, shows dashboard
```

### Flow 2: Claim Submission (ML Only)
```
User fills 3-step form: Hospital Stay → Diagnosis & Billing → Documents
  → Frontend calls: POST /api/predict
     Body: { user_id, amount_billed, diagnosis }
  → Python fetches user age/gender from DB (auto-filled, not user-input)
  → model_loader.py preprocesses:
     - One-Hot encodes: Gender, Diagnosis
     - Adds StayDuration = 1 (default)
     - Aligns to 13 training features
  → Gradient Boosting model predicts: [0=genuine, 1=fraud]
  → Confidence threshold: if genuine but confidence < 90% → rejected
  → Creates new claim record in PostgreSQL
  → Returns: { claim_id, prediction_label, confidence, message }
```

### Flow 3: Image Verification (GPT-4o Vision)
```
If user uploads prescription + receipt images:
  → Frontend calls: POST /api/verify-images (multipart/form-data)
     Body: { claim_id, prescription_image, receipt_image }
  → Python saves to temp files
  → prescription_verifier.py:
     1. GPT-4o Vision extracts text from prescription image
     2. GPT-4o extracts medicine names from OCR text
     3. GPT-4o Vision extracts text from receipt image
     4. GPT-4o extracts product names from receipt text
     5. GPT-4o compares medicine lists (AI-powered fuzzy matching)
     6. If unprescribed items found → re-checks prescription image
     7. Returns: match_percentage (0-100%)
  → Combined score = (ML confidence% + Image score%) / 2
  → If combined ≥ 80% → claim stays genuine
  → If combined < 80% → claim.ml_status changed to 'fake'
  → Updates claim record in DB with image_score, images status
```

### Flow 4: Payout Trigger & Execution
```
User clicks "Claim Amount" on an approved claim
  → Frontend calls: PUT /api/claims/{id}/trigger-payout
     Body: { payout_address: "addr_test1..." } (optional, defaults to user's wallet)
  → Python sets claim.payout_status = 'trigger' in DB

  [60 seconds later...]

  → Go automation service (database.go) polls DB:
     SELECT claims WHERE payout_status = 'trigger' AND ml_status = 'genuine'
  → For each claim:
     1. crypto.go: HashUserID(name, email) → Blake2b-256 hash
     2. blockchain.go: Build PayoutRequest
        - recipientAddress = user's wallet
        - amountLovelace = amount_billed × 1,000,000
        - hashedUserId = Blake2b hash
        - claimMetadata = { claim_id, user_id, amount, ml_status, patient_name, ... }
     3. HTTP POST to Node.js: http://127.0.0.1:3001/api/payout-transaction
     4. app.ts builds Cardano transaction:
        - tx.sendLovelace(recipient, amount)
        - tx.setMetadata(674, { msg, claim_id, user_id, hashed_user_id, smart_contract, ... })
        - tx.build() → signs with treasury mnemonic → submits to network
     5. Returns txHash to Go
     6. Go updates DB: claim.payout_status = 'completed', claim.tx_hash = txHash
     7. Go inserts into public_payouts table (privacy-preserving)
     8. Go inserts into blockchain_transactions table
     9. Go periodically updates confirmations from Blockfrost
```

### Flow 5: Transaction Viewing
```
User clicks "View Transaction" on a completed claim
  → TransactionDetailsModal.vue opens
  → Frontend calls: GET /service/api/transaction/{txHash}
  → Node.js fetches from Blockfrost: tx details, metadata, UTXOs, latest block
  → Returns: block_height, slot, confirmations, metadata (label 674), fees, explorer URL
  → Modal displays all blockchain data + link to CardanoScan
```

---

## 5. Directory Structure & File-by-File Breakdown

### 5.1 Root Files

| File | Purpose |
|------|---------|
| **`.env`** | Environment variables: `DATABASE_URL`, `BLOCKFROST_API_KEY`, `TREASURY_ADDRESS`, `TREASURY_MNEMONIC`. Loaded by all services. |
| **`.gitignore`** | Ignores: `node_modules/`, `venv/`, `__pycache__/`, `.env`, `*.mnemonic`, `dist/`, `*.pkl` patterns, IDE files, OS files. |
| **`README.md`** | Project overview with architecture diagram, setup guide, API docs, tech stack, Aiken contract section. |
| **`start.sh`** | **Master control script** (265 lines). Commands: `start` (all + ngrok), `local` (no ngrok), `stop`, `restart`, `status`. Manages Nginx, Python ML, Node.js blockchain, Go automation, ngrok. Color-coded output, health checks, PID tracking, log file paths. |

---

### 5.2 Frontend — `client/`

**Build**: `npm run build` → outputs to `client/dist/` (served by Nginx)

| File | Lines | Purpose |
|------|-------|---------|
| **`package.json`** | 34 | Dependencies: Vue 3.5, MeshSDK 1.9-beta, Axios, Heroicons, vue3-toastify. DevDeps: Vite 7.2, TailwindCSS, PostCSS, vite-plugin-node-polyfills. |
| **`vite.config.js`** | 15 | Vite config with Vue plugin + `nodePolyfills` plugin (provides `crypto`, `stream`, `buffer`, `process` for MeshSDK to work in browser). |
| **`tailwind.config.js`** | 40 | Custom color palette: `main-blue` (#264a70), `main-green` (#11998e), `accent-orange` (#e97d30), plus `secondary-blue`, `light-gray`, `dark-gray`, `success-green`, `danger-red`, `warning-yellow`. Inter font family. Custom shadow tokens. Dark mode via `class`. |
| **`postcss.config.js`** | — | Standard TailwindCSS + autoprefixer PostCSS config. |
| **`vercel.json`** | — | SPA rewrite rule for Vercel deployment (fallback to `index.html`). |
| **`index.html`** | — | Entry HTML with `<div id="app">`, loads `main.js`. |

#### `src/` — Source Files

| File | Lines | Purpose |
|------|-------|---------|
| **`main.js`** | 7 | App entry point. Imports Vue, global CSS, toast CSS. Mounts `<App>` to `#app`. |
| **`App.vue`** | 417 | **Root component & layout controller**. Manages: wallet connection state, user data fetching, claim stats computation. Shows hero section (pre-connect) or dashboard (post-connect). Contains: NavBar, RecentActivity (public), StatusCards (4 stats), ActionCards (submit/history), ClaimForm (inline toggle), ClaimsList (modal), footer. Auto-refreshes user data every 30s while connected. Handles payout trigger with toast notifications. |
| **`api.js`** | 95 | **Axios API client**. Base URL: `/api` (proxied by Nginx to Python :8000). Methods: `healthCheck()`, `getUserByWallet(address)`, `submitClaim(data)`, `triggerPayout(claimId, walletAddress)`, `verifyImages(claimId, prescriptionFile, receiptFile)`, `getModelInfo()`. 10s default timeout, 60s for image verification. Error interceptor logs to console. |
| **`style.css`** | 210 | **Global styles**. Imports Inter font from Google Fonts. Tailwind layers: `@tailwind base/components/utilities`. CSS variables for colors. Components: `.glass` (glassmorphism), `.card-base`, `.btn-primary/success/danger/secondary`, `.input-base`, `.badge-*` variants. Utilities: `.animate-float`, `.text-gradient`, `.scrollbar-thin`. Keyframes: `spin`, `float`, `pulse`. Toast notification overrides. |

#### `src/components/` — Vue Components

| Component | Lines | Purpose |
|-----------|-------|---------|
| **`NavBar.vue`** | 48 | Fixed top navigation bar with glassmorphism (`bg-white/80 backdrop-blur-xl`). HealthTrust logo with gradient glow effect. "Preprod Testnet" badge (desktop). Embeds `WalletSelector`. Emits: `wallet-connected`, `disconnect`. |
| **`WalletSelector.vue`** | 451 | **Cardano wallet connection manager**. Detects installed wallets via `window.cardano` (CIP-30). Supports: Nami, Eternl, Lace, Flint, Typhon, Yoroi, GeroWallet, NuFi. Shows modal with 3-column wallet grid. On connect: enables wallet → gets used addresses → gets change address → resolves to Bech32 → emits address + wallet instance. Disconnect clears localStorage. Help text with wallet download links. |
| **`ClaimForm.vue`** | 653 | **3-step claim submission wizard**. Step 1: Hospital stay dates (admission/discharge, auto-computes days). Step 2: Diagnosis dropdown (8 options matching ML model features) + amount billed in ADA. Step 3: Optional document upload (receipt + prescription, max 10MB each). Summary card before submit. On submit: calls `/predict` → if images uploaded, calls `/verify-images` → shows result with ML confidence %, image score %, combined score %. Cancel button aborts request. Color-coded result: green (approved) / red (rejected). |
| **`ClaimsList.vue`** | 292 | **Claims history grid**. Displays all user claims as cards (2-column on desktop). Each card shows: claim ID, amount (ADA), date, diagnosis, age, gender. Status badges: ML status (genuine/fake/pending), image verification status, payout status. Actions: "Claim Amount" (trigger payout), "View Transaction" (opens TransactionDetailsModal), "Processing..." spinner, "Rejected" indicator. Fake claims warning banner at bottom. Refresh button. |
| **`StatusCard.vue`** | 152 | **Dashboard stat card**. Props: title, count, description, tooltip, icon, variant. Icons from Heroicons: check, warning, error, clock, document. Color variants: success (green), warning (yellow), danger (red), info (blue). Hover scale effect on icon. |
| **`ActionCard.vue`** | 131 | **Quick action card**. Props: title, description, icon, variant. Icons: upload, view, transfer, check, clipboard (Heroicons). Top accent bar colored by variant. Hover shadow transition. Slot: `#actions` for custom buttons. |
| **`RecentActivity.vue`** | 261 | **Public activity feed** (shown before wallet connect). Fetches `GET /api/recent-activity?limit=5`. Displays completed claims with: approved/rejected status, amount, diagnosis, transaction hash (truncated), copy button. Click opens TransactionDetailsModal. "View all on CardanoScan" link. Auto-fetches on mount. Loading spinner, error state, empty state. |
| **`TransactionDetailsModal.vue`** | 351 | **Blockchain transaction detail viewer**. Shows: TX hash (copyable), block height, epoch/slot, claim metadata (ID, amount, age, gender, diagnosis, timestamp), "Verified on Cardano Blockchain" notice, CardanoScan explorer link. Fetches additional data from `/service/api/transaction/{txHash}` for block confirmations. |
| **`BaseModal.vue`** | 105 | **Reusable modal component**. Teleported to `<body>`. Props: `modelValue` (v-model), `title`. Gradient header (blue→green), scrollable body, optional footer. Close on backdrop click or X button. Prevents body scroll when open. Slide-in animation. |
| **`HelloWorld.vue`** | — | Vue boilerplate (unused). |

#### `src/composables/`

| File | Lines | Purpose |
|------|-------|---------|
| **`useToast.js`** | 59 | Composable wrapping `vue3-toastify`. Exports: `showSuccess()`, `showError()`, `showInfo()`, `showWarning()`. All positioned top-right with 3-4s auto-close, progress bar, draggable. |

---

### 5.3 ML Service — `ml-service/`

**Runtime**: Python 3.10 + FastAPI + Uvicorn on port 8000 (bound to 127.0.0.1)

| File | Lines | Purpose |
|------|-------|---------|
| **`main.py`** | ~350 | **FastAPI application with all endpoints**. On startup: initializes DB tables + warms up ML model. Endpoints: `GET /` (health check with model stats), `POST /predict` (claim submission + ML prediction), `GET /users/{wallet_address}` (user profile + claims), `PUT /claims/{id}/trigger-payout` (set payout_status to 'trigger'), `GET /model/info` (model metadata + top features), `GET /recent-activity` (public feed of completed claims), `POST /verify-images` (GPT-4o prescription vs receipt verification). Detailed terminal logging for every claim submission. CORS enabled for all origins. |
| **`model_loader.py`** | 203 | **ML model wrapper class `FraudDetectionModel`**. Loads 4 pickle artifacts from `models/` directory: `best_model.pkl` (Gradient Boosting), `scaler.pkl` (StandardScaler), `feature_names.pkl` (13 feature columns), `metadata.pkl` (accuracy, F1, training date). `preprocess_input()`: creates DataFrame, one-hot encodes Gender + Diagnosis, aligns to exact training feature order (13 columns), fills missing with 0. `predict()`: runs model, gets probability, applies 90% confidence threshold (if genuine but < 90% confidence → rejected as 'fake' with reason 'low_confidence'). `get_feature_importance()`: returns top N features from Gradient Boosting's `feature_importances_`. Singleton pattern via `get_model()`. |
| **`database.py`** | 110 | **SQLAlchemy ORM models**. `User`: id, name, email, wallet_address, age, gender, expiry_date, premium. `Claim`: id, user_id, amount_billed, age, gender, diagnosis, ml_status, confidence, images, image_score, payout_status, payout_address, tx_hash, block_height, slot. `PublicPayout`: id, hashed_user_id, amount, tx_hash. Constraints: age 0-150, gender Male/Female, ml_status genuine/fake/pending, payout_status pending/trigger/completed. Relationships: User→Claims (one-to-many). `get_db()` dependency, `init_db()` creates tables. Connection string from `.env`. |
| **`prescription_verifier.py`** | 620 | **GPT-4o Vision prescription verification system**. Flow: (1) `extract_medicines_from_prescription()` — sends prescription image to GPT-4o Vision for OCR, then extracts medicine names from OCR text. (2) `extract_medicines_from_receipt()` — same for pharmacy receipt. (3) `ai_compare_medicines()` — detailed GPT-4o prompt comparing prescribed vs purchased medicines with fuzzy matching, brand/generic equivalence, OCR error tolerance, handwriting interpretation. (4) `recheck_prescription_for_missing_items()` — double-checks prescription for any items found on receipt but missed in first pass. Supports: JPG, JPEG, PNG, PDF (via pdf2image). Returns: `(is_genuine, match_percentage)`. Threshold: ≥80% match = genuine. |
| **`export_model.py`** | 140 | **Model training & export script**. Loads `data/healthcare_claims.csv` (20,000 rows). Feature engineering: FraudStatus binary target, StayDuration from dates. Trains 7 models: Logistic Regression, SVC, KNN, Decision Tree, Random Forest, Gradient Boosting, Voting Ensemble. Selects best by F1 score (Gradient Boosting wins). Exports to `models/`: `best_model.pkl`, `scaler.pkl`, `feature_names.pkl`, `metadata.pkl`. |
| **`requirements.txt`** | 13 | Python dependencies: fastapi, uvicorn, pydantic, sqlalchemy, psycopg2-binary, python-dotenv, scikit-learn, pandas, numpy, python-multipart, openai, pdf2image, pillow. |
| **`setup.sh`** | — | Bash script to create venv and install requirements. |
| **`start-ml-service.sh`** | — | Bash script to activate venv and run uvicorn. |

#### `models/` — Trained Model Artifacts

| File | Purpose |
|------|---------|
| **`best_model.pkl`** | Serialized Gradient Boosting classifier (scikit-learn) |
| **`scaler.pkl`** | StandardScaler fitted on training data (not used by Gradient Boosting but exported for other models) |
| **`feature_names.pkl`** | List of 13 feature column names after one-hot encoding |
| **`metadata.pkl`** | Dictionary: model_name, accuracy (0.863), f1_score, n_features (13), training_date |

---

### 5.4 Blockchain Service — `server/blockchain-service/`

**Runtime**: Node.js 22 + Express + TypeScript on port 3001 (bound to 127.0.0.1)

| File | Lines | Purpose |
|------|-------|---------|
| **`src/app.ts`** | ~385 | **Express server with Cardano blockchain integration**. Initializes: BlockfrostProvider (Preprod), MeshWallet (from treasury mnemonic), Aiken compiled code constant, script address (for monitoring). `withTimeout()` helper wraps all MeshSDK calls to prevent silent hangs. `getScriptUtxos()` fetches UTXOs at smart contract address via Blockfrost REST API. `totalLovelace()` sums lovelace across UTXOs. **Endpoints**: `GET /health` (wallet + script balances, UTxO counts), `GET /api/balance` (detailed balance breakdown), `GET /api/epoch` (current epoch/slot from Blockfrost), `POST /api/payout-transaction` (builds Transaction, attaches CIP-20 metadata label 674, signs with treasury key, submits to Cardano), `GET /api/transaction/:txHash` (fetches full TX details + metadata + confirmations from Blockfrost). |
| **`package.json`** | 31 | Dependencies: @meshsdk/core 1.7.8+, express, dotenv, cors. DevDeps: TypeScript 5.3, ts-node, nodemon, @types/express, @types/cors, @types/node. Scripts: `dev` (nodemon), `start` (ts-node), `build` (tsc). |
| **`tsconfig.json`** | 23 | TypeScript config: ES2020 target, commonjs modules, strict mode, esModuleInterop, resolveJsonModule. Output: `dist/`. |
| **`Procfile`** | — | `web: npx ts-node src/app.ts` (for Railway/Heroku deployment). |
| **`railway.json`** | — | Railway deployment config. |
| **`generate-alice-wallet.js`** | — | Utility to generate a test wallet for Alice. |

#### Payout Transaction Metadata (CIP-20, label 674)

Every payout transaction includes this on-chain metadata:

```json
{
  "msg": ["HealthTrust Insurance Payout"],
  "claim_id": 75,
  "user_id": 1,
  "amount_ada": 15.50,
  "ml_status": "genuine",
  "claim_type": "healthcare",
  "patient": "Alice Johnson",
  "hashed_user_id": "a3b4c5d6...",
  "smart_contract": "addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k",
  "approved_at": "2026-02-21T18:30:00.000Z",
  "network": "preprod"
}
```

---

### 5.5 Automation Service — `automation-service/`

**Runtime**: Go 1.21+ (compiled binary, runs as background daemon)

| File | Lines | Purpose |
|------|-------|---------|
| **`database.go`** | 214 | **Main entry point + DB operations**. `main()`: loads `.env`, connects to PostgreSQL, starts 60-second ticker. `processPayouts()`: queries `claims WHERE payout_status = 'trigger' AND ml_status = 'genuine'` (also checks `payout_address` for custom recipient). For each claim: hashes user ID, calls `SubmitTransaction()`, updates claim status to 'completed', inserts into `public_payouts` table. `GetPendingPayouts()` uses `COALESCE(c.payout_address, u.wallet_address)` to support custom payout addresses. |
| **`blockchain.go`** | 244 | **Blockchain service client**. `SubmitTransaction()`: converts ADA to lovelace, builds JSON payload with claim metadata, POSTs to `http://127.0.0.1:3001/api/payout-transaction` (120s timeout). Parses response for txHash. `StoreBlockchainTransaction()`: inserts into `blockchain_transactions` table. `UpdateTransactionConfirmations()`: polls pending transactions via `GET /api/transaction/{txHash}`, updates confirmations, block_height, slot, fees in DB. `SyncBlockHeightToClaim()`: copies block_height to claims table. |
| **`crypto.go`** | 27 | **Privacy hashing**. `HashUserID(name, email)`: concatenates name+email, computes Blake2b-256 hash, returns hex string. Fallback to SHA-256 if Blake2b fails. This hash goes on-chain in metadata for privacy-preserving public records. |
| **`go.mod`** | 16 | Module: `cardano-insurance-automation`. Dependencies: blockfrost-go, godotenv, lib/pq, golang.org/x/crypto. |

---

### 5.6 Smart Contract — `aiken-contracts/`

**Language**: Aiken 1.1.19, targeting Plutus V3 (Conway era)

| File | Lines | Purpose |
|------|-------|---------|
| **`validators/insurance_gatekeeper.ak`** | 58 | **On-chain Plutus V3 validator**. Types: `InsuranceDatum { hashed_user_id: ByteArray }`, `InsuranceRedeemer { Void }`. Treasury PKH hardcoded: `9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057`. Validation logic: (1) Transaction MUST be signed by treasury PKH (checked via `tx.extra_signatories`), (2) Datum must be present with non-empty `hashed_user_id`. Both conditions must pass. `else(_)` handler fails all other purposes. |
| **`aiken.toml`** | 20 | Project config: name `cardano-insurance/insurance-gatekeeper`, compiler v1.1.19, plutus v3, Apache-2.0 license. Dependency: `aiken-lang/stdlib` v3.0.0. |
| **`build/`** | — | Compiled output from `aiken build`. Contains `plutus.json` with CBOR-encoded validator, and `packages/` with stdlib source. |

#### Contract Status

| Property | Value |
|----------|-------|
| Script Hash | `5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e` |
| Script Address | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |
| Locked Funds | 500 tADA (locked via manual transaction) |
| Spending | **Disabled** — MeshSDK v1 has a known bug with Plutus V3 CBOR serialization (`MalformedScriptWitnesses`). The contract is compiled, deployed, and monitored (balance shown in `/health` endpoint). Spending will be enabled when MeshSDK v2 releases. |

---

### 5.7 Database — `database/`

| File | Lines | Purpose |
|------|-------|---------|
| **`schema.sql`** | 70 | **Core schema**. Creates tables: `users` (id, name, email, wallet_address, expiry_date, premium), `claims` (id, user_id, amount_billed, age, gender, diagnosis, ml_status, payout_status, tx_hash), `public_payouts` (hashed_user_id, amount, tx_hash). Indexes on wallet_address, user_id, payout_status, ml_status, tx_hash. `updated_at` trigger function. Comments on all tables/columns. |
| **`seed.sql`** | 20 | **Initial test data**. Inserts 3 users: Alice Johnson, Bob Smith, Carol Williams with Preprod testnet wallet addresses, expiry dates, premiums. |
| **`migrations/003_blockchain_transactions.sql`** | 91 | Adds `blockchain_transactions` table: tx_hash (PK), claim_id (FK), block_height, block_hash, block_timestamp, slot, confirmations, status, size, gas_fees, total_output, network, metadata (JSONB), explorer_url. Adds tx_hash column to claims if missing. Creates `claim_transactions` view. |
| **`migrations/004_add_payout_date.sql`** | 33 | Adds `payout_date` column to claims. Creates `claim_transactions` view joining claims with blockchain_transactions. |
| **`migrations/005_add_image_verification.sql`** | 16 | Adds to claims: `prescription_image` (BYTEA), `receipt_image` (BYTEA), `images` (VARCHAR — 'genuine' or 'fake'). |

---

### 5.8 Treasury Wallet — `treasury-wallet/`

| File | Lines | Purpose |
|------|-------|---------|
| **`generate-wallet.js`** | 80 | **Treasury wallet generator**. Uses MeshSDK to `MeshWallet.brew()` a new 24-word mnemonic, creates wallet (networkId=0 for Preprod), gets change address. Saves `treasury.mnemonic` and `treasury.addr` files. Updates `../.env` with TREASURY_ADDRESS and TREASURY_MNEMONIC. Prints next steps (fund via faucet, verify on CardanoScan). |
| **`generate-user-wallets.js`** | 100 | **Test user wallet generator**. Generates wallets for Alice, Bob, Carol. Saves mnemonics and addresses to `users/{name}/`. Generates `update_user_wallets.sql` to update DB. |
| **`update_user_wallets.sql`** | — | Generated SQL: `UPDATE users SET wallet_address = '...' WHERE id = N;` for each user. |
| **`treasury.addr`** | 1 | Treasury wallet Bech32 address. |
| **`treasury.mnemonic`** | 1 | Treasury 24-word mnemonic (gitignored). |
| **`TREASURY_WALLET.md`** | — | Documentation about the treasury wallet setup. |
| **`package.json`** | — | Dependencies for wallet generation scripts (MeshSDK). |
| **`users/`** | — | Subdirectories for alice_johnson, bob_smith, carol_williams — each with `address.txt` and `mnemonic.txt`. |

#### Treasury Wallet

| Property | Value |
|----------|-------|
| Address | `addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78` |
| PKH | `9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057` |
| Network | Cardano Preprod Testnet |
| Mnemonic | 24 words (stored in `.env` and `treasury.mnemonic`, both gitignored) |

---

### 5.9 Deployment — `deploy/`

| File | Lines | Purpose |
|------|-------|---------|
| **`healthtrust-local.nginx`** | 78 | **Nginx reverse proxy config** (currently active). Rate limiting: 10r/s for API, 30r/s general. Routes: `/` → `client/dist/` (Vue SPA with `try_files` fallback), `/api/*` → rewrite strip prefix → proxy to Python :8000, `/service/*` → rewrite strip prefix → proxy to Node.js :3001. 20MB body limit for image uploads. 120s proxy timeout for GPT-4o calls. |
| **`healthtrust.nginx`** | — | Production Nginx config (with TLS/SSL). |
| **`healthtrust-ml.service`** | 37 | systemd unit for ML service. Runs as `healthtrust` user. ExecStart: uvicorn with 2 workers. Security: NoNewPrivileges, ProtectSystem=strict, ProtectHome, PrivateTmp. Requires PostgreSQL. |
| **`healthtrust-blockchain.service`** | 31 | systemd unit for blockchain service. ExecStart: `node -r ts-node/register src/app.ts`. Same security hardening. |
| **`healthtrust-go.service`** | 32 | systemd unit for Go automation. ExecStart: compiled binary. Requires PostgreSQL + blockchain service. |
| **`deploy.sh`** | — | Automated deployment script for production server setup. |

---

### 5.10 Data — `data/`

| File | Purpose |
|------|---------|
| **`healthcare_claims.csv`** | **Training dataset**: 20,000 simulated healthcare insurance claims. Columns: Patient ID, Age, Gender, Date Admitted, Date Discharged, Diagnosis (Pregnancy, Hypertension, Diabetes, Pneumonia, Gastroenteritis, Cesarean Section, Cataract Surgery, Migraine), Amount Billed, Fraud Type (No Fraud, Phantom Billing, etc.). Used by `export_model.py` to train the ML model. |
| **`model_training.ipynb`** | **Jupyter Notebook**: Full ML training pipeline with exploratory data analysis, feature engineering, model comparison (7 models), evaluation metrics, confusion matrices, feature importance plots. Documents the research process. |

---

## 6. Database Schema

**Database**: PostgreSQL 18, name: `HealthTrust`

```
┌─────────────────────────────┐     ┌─────────────────────────────────────────────┐
│          users              │     │                 claims                       │
├─────────────────────────────┤     ├─────────────────────────────────────────────┤
│ id          SERIAL PK       │←────│ user_id       INTEGER FK                    │
│ name        VARCHAR(255)    │     │ id            SERIAL PK                     │
│ email       VARCHAR(255) UQ │     │ amount_billed DECIMAL(10,2)                 │
│ wallet_address VARCHAR(255) │     │ age           INTEGER (1-150)               │
│ age         INTEGER         │     │ gender        VARCHAR(10) (Male/Female)     │
│ gender      VARCHAR(10)     │     │ diagnosis     VARCHAR(100)                  │
│ expiry_date DATE            │     │ ml_status     VARCHAR(20) (genuine/fake/pending) │
│ premium     DECIMAL(10,2)   │     │ confidence    DECIMAL(5,4) (0.0000-1.0000)  │
│ created_at  TIMESTAMP       │     │ images        VARCHAR(20) (genuine/fake)    │
│ updated_at  TIMESTAMP       │     │ image_score   DECIMAL(5,2) (0-100)          │
└─────────────────────────────┘     │ payout_status VARCHAR(20) (pending/trigger/completed) │
                                    │ payout_address VARCHAR(255)                 │
                                    │ tx_hash       VARCHAR(255)                  │
                                    │ block_height  INTEGER                       │
                                    │ slot          INTEGER                       │
                                    │ created_at    TIMESTAMP                     │
                                    │ updated_at    TIMESTAMP                     │
                                    └─────────────────────────────────────────────┘

┌─────────────────────────────┐     ┌─────────────────────────────────────────────┐
│      public_payouts         │     │         blockchain_transactions              │
├─────────────────────────────┤     ├─────────────────────────────────────────────┤
│ id          SERIAL PK       │     │ tx_hash        VARCHAR(64) PK               │
│ hashed_user_id VARCHAR(64)  │     │ claim_id       INTEGER FK → claims           │
│ amount      DECIMAL(10,2)   │     │ block_height   BIGINT                       │
│ tx_hash     VARCHAR(255) UQ │     │ block_hash     VARCHAR(64)                  │
│ timestamp   TIMESTAMP       │     │ block_timestamp TIMESTAMP                   │
└─────────────────────────────┘     │ slot           BIGINT                       │
                                    │ confirmations  INTEGER                      │
                                    │ status         VARCHAR(20)                  │
                                    │ size           INTEGER                      │
                                    │ gas_fees       BIGINT                       │
                                    │ total_output   BIGINT                       │
                                    │ network        VARCHAR(20)                  │
                                    │ metadata       JSONB                        │
                                    │ explorer_url   TEXT                         │
                                    │ fetched_at     TIMESTAMP                    │
                                    │ updated_at     TIMESTAMP                    │
                                    └─────────────────────────────────────────────┘
```

**View**: `claim_transactions` — joins `claims` with `blockchain_transactions` for unified query.

---

## 7. API Reference

### Python ML Service (port 8000, proxied at `/api/`)

| Method | Endpoint | Request | Response | Description |
|--------|----------|---------|----------|-------------|
| GET | `/` | — | `{ status, model, accuracy, f1_score, timestamp }` | Health check with model info |
| POST | `/predict` | `{ user_id, amount_billed, diagnosis }` | `{ claim_id, prediction_label, confidence, ml_status, message }` | Submit claim for ML fraud detection |
| GET | `/users/{wallet_address}` | — | `{ user_id, name, email, wallet_address, age, gender, expiry_date, premium, claims[] }` | Get user by wallet + all claims |
| PUT | `/claims/{id}/trigger-payout` | `{ payout_address? }` | `{ message, claim_id, status, note }` | Trigger payout (sets status to 'trigger') |
| POST | `/verify-images` | FormData: `claim_id`, `prescription_image`, `receipt_image` | `{ claim_id, image_verification, combined_score, ml_score, final_status, message }` | GPT-4o prescription vs receipt verification |
| GET | `/model/info` | — | `{ model_name, accuracy, f1_score, n_features, training_date, top_features[] }` | Detailed model information |
| GET | `/recent-activity?limit=N` | — | `{ transactions[], count }` | Public feed of completed payouts |

### Node.js Blockchain Service (port 3001, proxied at `/service/`)

| Method | Endpoint | Request | Response | Description |
|--------|----------|---------|----------|-------------|
| GET | `/health` | — | `{ status, network, smartContract{}, treasuryWallet{}, totalBalanceADA }` | Service health + wallet/script balances |
| GET | `/api/balance` | — | `{ wallet{}, smartContract{}, totalBalanceADA }` | Detailed balance breakdown |
| GET | `/api/epoch` | — | `{ epoch, slot, block_height, block_time, network }` | Current Cardano epoch/slot info |
| POST | `/api/payout-transaction` | `{ recipientAddress, amountLovelace, hashedUserId, claimMetadata{} }` | `{ success, txHash, explorerUrl, network, timestamp }` | Build, sign & submit ADA payout |
| GET | `/api/transaction/:txHash` | — | `{ txHash, blockHeight, slot, confirmations, fees, metadata{}, inputs[], outputs[], explorerUrl }` | Full transaction details from Blockfrost |

---

## 8. Smart Contract Details

### Insurance Gatekeeper (Plutus V3)

The Aiken smart contract serves as the **on-chain governance layer**. It is compiled and deployed to Cardano Preprod with 500 tADA locked at its script address.

#### Validator Logic (Pseudocode)
```
WHEN spending from script:
  1. CHECK transaction.extra_signatories CONTAINS treasury_pkh
     → Ensures only the insurance treasury can authorize payouts
  2. CHECK datum.hashed_user_id IS NOT empty
     → Ensures every payout is linked to a specific (hashed) user
  3. BOTH conditions must be TRUE → allow spend
  4. ELSE → reject transaction
```

#### Data Types
- **Datum** (`InsuranceDatum`): `{ hashed_user_id: ByteArray }` — Blake2b-256 hash of (name + email)
- **Redeemer** (`InsuranceRedeemer`): `{ Void }` — empty, all validation is via signatures

#### Current Usage
The smart contract is **referenced but not spent** in the current system. Each payout transaction includes the script address in its metadata field, creating an on-chain link. The compiled code constant is stored in `app.ts` and the script address is derived using `resolvePlutusScriptAddress()`. The script's UTxO balance is monitored and displayed in the `/health` and `/api/balance` endpoints.

---

## 9. ML Model Details

### Training Pipeline

1. **Dataset**: 20,000 simulated healthcare claims (`data/healthcare_claims.csv`)
   - Features: Age, Gender, Date Admitted, Date Discharged, Diagnosis, Amount Billed
   - Target: Fraud Type (binary: No Fraud vs Phantom Billing/etc.)

2. **Feature Engineering**:
   - `FraudStatus`: binary (0=genuine, 1=fraud)
   - `StayDuration`: days between admission and discharge
   - One-Hot Encoding: Gender, Diagnosis → 13 features total
   - Train/Test split: 75/25, stratified

3. **Models Trained** (7 total):
   | Model | Accuracy | F1 Score |
   |-------|----------|----------|
   | Logistic Regression | ~82% | ~0.80 |
   | SVC | ~83% | ~0.81 |
   | KNN (k=30) | ~80% | ~0.78 |
   | Decision Tree | ~79% | ~0.77 |
   | Random Forest | ~85% | ~0.84 |
   | **Gradient Boosting** | **~86.3%** | **~0.85** |
   | Voting Ensemble | ~85% | ~0.84 |

4. **Selected Model**: Gradient Boosting Classifier (best F1 score)

5. **Confidence Threshold**: 90% — if the model predicts "genuine" but with < 90% confidence, the claim is automatically rejected and flagged for manual review.

### Image Verification

The image verification is a secondary layer using OpenAI's GPT-4o Vision:
- **4 API calls** per verification: 2 for OCR (prescription + receipt), 2 for extraction/comparison
- Handles: handwritten prescriptions, OCR errors, brand/generic equivalences, abbreviations
- Scoring: percentage of receipt items matched to prescription
- Combined with ML: `(ML_confidence% + Image_score%) / 2`
- Threshold: ≥ 80% combined → approved

---

## 10. Security & Privacy

### Privacy Measures
- **Blake2b-256 Hashing**: User identity (name + email) is hashed before going on-chain. The `public_payouts` table and on-chain metadata only contain the hash, never the actual user data.
- **On-chain metadata**: Only contains claim_id, amount, ml_status, hashed_user_id — no PII.

### Access Control
- All backend services bind to `127.0.0.1` (not exposed to internet directly).
- Nginx is the only public-facing service (port 80).
- Rate limiting: 10 req/s for API endpoints, 30 req/s for frontend.
- CORS enabled (should be restricted in production).

### Wallet Security
- Treasury mnemonic stored only in `.env` file (gitignored).
- Smart contract requires treasury signature for any fund withdrawal.
- CIP-30 wallet connection is client-side only (private keys never leave the browser).

### Deployment Hardening (systemd units)
- `NoNewPrivileges=true`
- `ProtectSystem=strict`
- `ProtectHome=true`
- `PrivateTmp=true`

---

## 11. Deployment Architecture

### Local Development (Current)
```
ngrok (HTTPS tunnel)
  └── Nginx :80
       ├── /         → client/dist/ (Vue static build)
       ├── /api/*    → 127.0.0.1:8000 (Python FastAPI)
       └── /service/* → 127.0.0.1:3001 (Node.js Express)

Background:
  ├── Go automation (polling PostgreSQL every 60s)
  └── PostgreSQL :5432 (database: HealthTrust)
```

### Production (deploy/ configs)
- 3 systemd services: `healthtrust-ml`, `healthtrust-blockchain`, `healthtrust-go`
- Nginx with TLS (certbot/Let's Encrypt)
- Application user: `healthtrust` (non-root)
- Working directory: `/opt/healthtrust/`

### Management
```bash
bash start.sh           # Start all + ngrok
bash start.sh local     # Start all, localhost only
bash start.sh stop      # Stop everything
bash start.sh restart   # Restart all
bash start.sh status    # Check all service statuses
```

---

## 12. Known Limitations

1. **MeshSDK v1 + Plutus V3 CBOR Bug**: MeshSDK v1.8.x has incompatible hashing between `resolvePlutusScriptAddress` and `resolveScriptHash` for Plutus V3 scripts. This causes `MalformedScriptWitnesses` errors when attempting to spend from the smart contract. The 500 tADA locked at the script address is viewable but not spendable through MeshSDK. Fix expected in MeshSDK v2.

2. **Training Data**: The ML model is trained on simulated (synthetic) healthcare claims data, not real-world insurance claims. Production deployment would require retraining on actual claims data.

3. **Image Verification Cost**: Each prescription verification requires 4 GPT-4o API calls (~$0.03-0.10 per verification). This adds latency (10-30 seconds) and cost.

4. **Single Treasury Wallet**: All payouts come from one treasury wallet. In production, this would need multi-sig or institutional custody.

5. **Preprod Testnet**: All transactions use test ADA (tADA) on Cardano's Preprod testnet. No real financial value is transferred.

6. **CORS Open**: Currently `allow_origins=["*"]` — should be restricted to the frontend domain in production.

7. **No Authentication**: The API has no JWT/session authentication. Wallet connection is the only identity mechanism.

---

*Generated: February 2026*
*Project: HealthTrust — Final Year Project*
*Author: Yadurshan R*
