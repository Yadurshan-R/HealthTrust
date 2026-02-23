# HealthTrust — Complete Technical Summary# 📖 HealthTrust — Complete Project Summary



> **Project:** Final Year Project (FYP)  > **Final Year Project** by Yadurshan R

> **Author:** Yadurshan  > AI-Powered Healthcare Insurance Fraud Detection on Cardano Blockchain

> **Type:** Decentralized Health Insurance dApp  

> **Languages:** Python · TypeScript · Go · Vue 3 (JavaScript) · Aiken · SQL  ---

> **Blockchain:** Cardano Preprod Testnet  

> **Live URL:** http://178.128.212.100  ## Table of Contents



---1. [Project Overview](#1-project-overview)

2. [System Architecture](#2-system-architecture)

## Table of Contents3. [Technology Stack](#3-technology-stack)

4. [Data Flow — End to End](#4-data-flow--end-to-end)

1. [Project Overview](#1-project-overview)5. [Directory Structure & File-by-File Breakdown](#5-directory-structure--file-by-file-breakdown)

2. [Architecture](#2-architecture)   - [Root Files](#51-root-files)

3. [Technology Stack](#3-technology-stack)   - [Frontend — `client/`](#52-frontend--client)

4. [Complete File-by-File Breakdown](#4-complete-file-by-file-breakdown)   - [ML Service — `ml-service/`](#53-ml-service--ml-service)

5. [Database Schema](#5-database-schema)   - [Blockchain Service — `server/blockchain-service/`](#54-blockchain-service--serverblockchain-service)

6. [ML Pipeline](#6-ml-pipeline)   - [Automation Service — `automation-service/`](#55-automation-service--automation-service)

7. [Image Verification System](#7-image-verification-system)   - [Smart Contract — `aiken-contracts/`](#56-smart-contract--aiken-contracts)

8. [Blockchain Integration](#8-blockchain-integration)   - [Database — `database/`](#57-database--database)

9. [Smart Contract (Aiken)](#9-smart-contract-aiken)   - [Treasury Wallet — `treasury-wallet/`](#58-treasury-wallet--treasury-wallet)

10. [Frontend Architecture](#10-frontend-architecture)   - [Deployment — `deploy/`](#59-deployment--deploy)

11. [Automation Service](#11-automation-service)   - [Data — `data/`](#510-data--data)

12. [API Endpoints](#12-api-endpoints)6. [Database Schema](#6-database-schema)

13. [Deployment Infrastructure](#13-deployment-infrastructure)7. [API Reference](#7-api-reference)

14. [Claim Lifecycle](#14-claim-lifecycle)8. [Smart Contract Details](#8-smart-contract-details)

15. [Security & Privacy](#15-security--privacy)9. [ML Model Details](#9-ml-model-details)

10. [Security & Privacy](#10-security--privacy)

---11. [Deployment Architecture](#11-deployment-architecture)

12. [Known Limitations](#12-known-limitations)

## 1. Project Overview

---

HealthTrust is a **decentralized health insurance application** that combines three verification layers to automate insurance claim processing:

## 1. Project Overview

1. **ML Fraud Detection** — A Gradient Boosting classifier trained on 20,000+ healthcare claims detects fraudulent submissions with 86.3% accuracy

2. **GPT-4o Vision Image Verification** — Prescription and pharmacy receipt images are compared using OpenAI's vision API to verify medicine matchingHealthTrust is a **decentralized healthcare insurance application** that combines three core technologies:

3. **Cardano Blockchain Payouts** — Approved claims trigger real ADA transactions on the Cardano Preprod testnet, recorded immutably on-chain with full claim metadata

1. **Machine Learning** — A Gradient Boosting classifier trained on 20,000 simulated healthcare claims detects fraudulent insurance claims with **86.3% accuracy**.

The system uses **five programming languages** across four microservices, connected through PostgreSQL and coordinated by Nginx reverse proxy.2. **Computer Vision** — GPT-4o Vision API compares doctor's prescriptions against pharmacy receipts to verify document authenticity.

3. **Cardano Blockchain** — All approved payouts are executed as on-chain ADA transactions on the Cardano Preprod testnet, with claim metadata immutably recorded using CIP-20 (label 674).

---

### How It Works (High Level)

## 2. Architecture

```

```1. Patient connects Cardano wallet (Nami/Eternl/Lace) to the Vue.js frontend

┌────────────────────────────────────────────────────────────────────┐2. Patient submits an insurance claim (diagnosis, amount, optional documents)

│                        Nginx (Port 80)                             │3. ML model predicts: genuine or fraudulent (with confidence score)

│         Reverse proxy — only public-facing process                 │4. If documents uploaded: GPT-4o Vision verifies prescription vs receipt

├──────────────┬───────────────────┬─────────────────────────────────┤5. Combined score = (ML confidence + Image verification) / 2

│  /           │  /api/            │  /service/                      │6. If combined score ≥ 80% → claim approved

│  Vue SPA     │  Python FastAPI   │  Node.js Express                │7. Patient clicks "Claim Amount" → payout_status set to 'trigger'

│  (static)    │  (port 8000)      │  (port 3001)                    │8. Go automation service (polling every 60s) picks up triggered claims

└──────────────┴──────┬────────────┴──────────┬──────────────────────┘9. Go calls Node.js blockchain service → builds & signs Cardano transaction

                      │                       │10. Treasury wallet sends ADA to patient's wallet with on-chain metadata

                 ┌────▼────┐            ┌─────▼──────┐11. Transaction hash stored in database, visible on CardanoScan explorer

                 │ PostgreSQL│           │ Blockfrost │```

                 │ (port 5432)│          │    API     │

                 └────┬──────┘          └─────┬──────┘---

                      │                       │

                 ┌────▼──────────────────────▼──┐## 2. System Architecture

                 │   Go Automation Service       │

                 │   (polls DB every 60 seconds) │```

                 └───────────────────────────────┘┌──────────────────────────────────────────────────────────────┐

```│                       Nginx (port 80)                        │

│                                                              │

**Data flow:**│   /         →  Vue.js SPA (static files from client/dist/)   │

1. User connects Cardano wallet (Nami/Lace/Eternl) → Vue frontend│   /api/*    →  Python FastAPI ML Service (127.0.0.1:8000)    │

2. Frontend calls `/api/predict` → Python ML service scores the claim│   /service/* → Node.js Blockchain Service (127.0.0.1:3001)   │

3. User optionally uploads prescription + receipt images → `/api/verify-images` → GPT-4o Vision└──────┬──────────────────┬──────────────────┬─────────────────┘

4. If approved, user clicks "Claim Amount" → `/api/claims/{id}/trigger-payout` sets `payout_status = 'trigger'`       │                  │                  │

5. Go service detects triggered claims → calls Node.js blockchain service → MeshSDK builds + signs + submits ADA transaction┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼────────────────┐

6. Transaction confirmed on Cardano → Go updates DB with `tx_hash`, `block_height`│  Vue 3 +    │   │  FastAPI    │   │  Express + MeshSDK    │

│  TailwindCSS│   │  + Uvicorn  │   │  + Blockfrost        │

---│  + MeshSDK  │   │  Port 8000  │   │  Port 3001           │

└─────────────┘   └──────┬──────┘   └──────┬────────────────┘

## 3. Technology Stack                         │                 │

                  ┌──────▼─────────────────▼────┐

| Layer | Technology | Version | Purpose |                  │       PostgreSQL (5432)      │

|-------|-----------|---------|---------|                  │       Database: HealthTrust  │

| **Frontend** | Vue 3 + Vite | 7.3 | Single Page Application |                  └──────────────┬───────────────┘

| **Styling** | TailwindCSS | 4.x | Utility-first CSS |                                 │

| **Wallet** | MeshSDK | 1.7 | Cardano wallet integration (CIP-30) |                  ┌──────────────▼───────────────┐

| **ML Service** | Python + FastAPI | 3.12 / 0.109 | Fraud detection API |                  │    Go Automation Service      │

| **ML Model** | scikit-learn (Gradient Boosting) | 1.6.1 | Binary classification |                  │    Polls DB every 60 seconds  │

| **Image AI** | OpenAI GPT-4o Vision | — | Prescription verification |                  │    Calls blockchain service   │

| **Database** | PostgreSQL | 16 | Persistent storage |                  └──────────────────────────────┘

| **ORM** | SQLAlchemy | 2.0.25 | Python ↔ PostgreSQL |                                 │

| **Blockchain Service** | Node.js + Express + MeshSDK | 22 / 1.7 | Transaction building |                  ┌──────────────▼───────────────┐

| **Automation** | Go | 1.22 | Polling + orchestration |                  │    Cardano Preprod Testnet    │

| **Smart Contract** | Aiken (Plutus V3) | — | On-chain validation |                  │    (via Blockfrost API)       │

| **Reverse Proxy** | Nginx | 1.24 | Routing + static files |                  └──────────────────────────────┘

| **Server** | DigitalOcean Droplet | Ubuntu 22.04 | Production hosting |```

| **Blockchain** | Cardano Preprod Testnet | — | ADA transactions |

| **Block Explorer** | Blockfrost API | — | Chain queries |### Service Communication



---| From | To | Method | Purpose |

|------|----|--------|---------|

## 4. Complete File-by-File Breakdown| Browser | Nginx :80 | HTTPS (ngrok) | All requests |

| Nginx | Python :8000 | HTTP reverse proxy | ML predictions, user CRUD |

### Root Files| Nginx | Node.js :3001 | HTTP reverse proxy | Blockchain operations |

| Frontend | Cardano | CIP-30 wallet API | Wallet connection (browser extension) |

| File | Purpose || Go Service | PostgreSQL :5432 | TCP (SQL) | Poll for triggered claims |

|------|---------|| Go Service | Node.js :3001 | HTTP POST | Submit payout transactions |

| `README.md` | User-facing guide with test wallets, setup instructions, architecture overview || Node.js | Blockfrost API | HTTPS | Build & submit Cardano transactions |

| `SUMMARY.md` | This file — developer-facing technical deep dive (not pushed to GitHub) || Python | OpenAI API | HTTPS | GPT-4o Vision for image verification |

| `.gitignore` | Excludes secrets (.env, mnemonics), build artifacts, node_modules, venv, .pkl models, lock files |

| `deploy.sh` | One-command deployment: builds frontend → rsync to server → restarts all systemd services |---

| `start.sh` | Local development starter (265 lines): starts all 4 services + optional ngrok tunnel, with stop/status/restart commands |

## 3. Technology Stack

---

| Layer | Technology | Version | Purpose |

### `ml-service/` — Python ML + API Backend|-------|-----------|---------|---------|

| **Frontend** | Vue 3 | 3.5.24 | Reactive SPA framework |

This is the **brain of the application**. It handles ML predictions, image verification, user management, and all API endpoints.| | Vite | 7.2.4 | Build tool & dev server |

| | TailwindCSS | 3.4.19 | Utility-first CSS |

| File | Lines | What It Does || | MeshSDK | 1.9.0-beta | Cardano wallet integration (CIP-30) |

|------|-------|-------------|| | Heroicons | 2.2.0 | SVG icon library |

| **`main.py`** | 53 | FastAPI app entry point. Sets up CORS middleware, registers router from `routes.py`, warms up ML model on startup, initializes database tables. Runs via Uvicorn. || | Axios | 1.13.2 | HTTP client |

| **`routes.py`** | 514 | **All API endpoint logic.** Contains 9 Pydantic request/response models and 8 route handlers. This is the largest Python file and the core of the business logic. || | vue3-toastify | 0.2.8 | Toast notifications |

| **`model_loader.py`** | 203 | `FraudDetectionModel` class — loads `.pkl` artifacts (model, scaler, feature names, metadata), preprocesses input with one-hot encoding to match training features, applies **confidence threshold** (90%) to reject low-confidence genuine predictions. Singleton pattern via `get_model()`. || | vite-plugin-node-polyfills | 0.25.0 | Node.js polyfills for MeshSDK |

| **`database.py`** | 113 | SQLAlchemy ORM models (`User`, `Claim`, `PublicPayout`) matching PostgreSQL schema. Defines all CHECK constraints, relationships, and the `get_db()` dependency. Reads `DATABASE_URL` from `.env`. || **ML Service** | Python | 3.10 | Runtime |

| **`prescription_verifier.py`** | 620 | **GPT-4o Vision prescription verification system.** Four-stage pipeline: (1) extract medicines from prescription image via GPT-4o vision, (2) extract medicines from receipt image, (3) AI-powered medicine comparison with medical knowledge, (4) targeted re-check for missed items. Handles abbreviations, brand/generic equivalents, OCR errors. Returns `(is_genuine, match_percentage)`. || | FastAPI | 0.109.0 | REST API framework |

| **`export_model.py`** | 168 | Standalone script to retrain & export the ML model. Loads `data/healthcare_claims.csv`, engineers features (StayDuration, one-hot encoding), trains 7 models (Logistic Regression, SVC, KNN, Decision Tree, Random Forest, Gradient Boosting, Voting Classifier), picks best by F1 score, exports to `models/` as `.pkl` files. || | Uvicorn | 0.27.0 | ASGI server |

| **`requirements.txt`** | 13 | Python dependencies: FastAPI, Uvicorn, SQLAlchemy, scikit-learn, pandas, openai, pdf2image, etc. || | scikit-learn | 1.6.1 | ML model (Gradient Boosting) |

| **`setup.sh`** | 77 | Creates venv, installs dependencies, generates `.env` template if missing. || | SQLAlchemy | 2.0.25 | ORM for PostgreSQL |

| **`LICENSE`** | — | MIT License || | OpenAI | 1.59.7 | GPT-4o Vision API |

| | Pandas | 2.2.3 | Data processing |

#### Key Logic in `routes.py`:| | Pydantic | 2.5.3 | Request/response validation |

| **Blockchain** | Node.js | 22 | Runtime |

- **`POST /predict`** — Takes `user_id`, `amount_billed`, `diagnosis`. Auto-fetches age/gender from user DB. Runs ML prediction with 90% confidence threshold. Saves claim with `ml_status` and `payout_status` (set to `'rejected'` if fake, `'pending'` if genuine). Prints detailed terminal report.| | Express | 4.18.2 | HTTP server |

| | MeshSDK | 1.7.8+ | Cardano transaction building |

- **`POST /verify-images`** — Accepts `claim_id` + two image uploads (prescription, receipt). Calls `prescription_verifier.verify_prescription()`. Calculates `combined_score = (ML% + image%) / 2`. If ≥80%: genuine. Updates only `claim.images` and `claim.image_score` — **never overwrites** `ml_status` (ML and image results are independent). Sets `payout_status='rejected'` if images fail.| | Blockfrost | (via fetch) | Cardano node gateway |

| | TypeScript | 5.3.3 | Type-safe development |

- **`GET /users/{wallet_address}`** — Returns user + claims. If wallet not in DB, **auto-registers** new user with random age/gender and 1-year expiry. Each claim includes `can_claim` boolean computed as `ml_status=='genuine' AND payout_status=='pending' AND images!='fake'`.| | ts-node | 10.9.2 | TypeScript execution |

| **Automation** | Go | 1.21+ | Runtime |

- **`PUT /claims/{id}/trigger-payout`** — Guards: must be genuine ML status, images not fake, payout status pending. Sets `payout_status='trigger'`. The Go automation service picks this up within 60 seconds.| | lib/pq | 1.10.9 | PostgreSQL driver |

| | golang.org/x/crypto | 0.18.0 | Blake2b-256 hashing |

- **`PUT /users/{wallet}/profile`** — Updates name, age, gender for newly registered users.| | godotenv | 1.5.1 | Environment variable loading |

| **Smart Contract** | Aiken | 1.1.19 | Cardano smart contract language |

- **`GET /recent-activity`** — Returns last 10 claims (both approved and rejected) for the landing page. Determines status: rejected if `ml_status='fake'` OR `images='fake'`.| | Plutus V3 | Conway era | On-chain validator |

| | aiken-lang/stdlib | 3.0.0 | Standard library |

---| **Database** | PostgreSQL | 18 | Relational database |

| **Reverse Proxy** | Nginx | 1.18 | Load balancing, static files, rate limiting |

### `server/blockchain-service/` — Node.js Blockchain Service| **Tunnel** | ngrok | latest | HTTPS tunnel for public access |



| File | Lines | What It Does |---

|------|-------|-------------|

| **`src/app.ts`** | 410 | Express server with MeshSDK. Initializes treasury wallet from mnemonic, resolves Aiken smart contract address. Five endpoints: `/health`, `/api/payout-transaction`, `/api/transaction/:txHash`, `/api/balance`, `/api/epoch`. Builds and signs ADA transactions with CIP-20 metadata (label 674). |## 4. Data Flow — End to End

| **`package.json`** | — | Dependencies: express, @meshsdk/core, cors, dotenv, ts-node, typescript |

| **`tsconfig.json`** | — | TypeScript config targeting ES2020 |### Flow 1: Wallet Connection (Open Registration)

```

#### Key Logic in `app.ts`:User opens app → Clicks "Connect Wallet"

  → WalletSelector.vue detects installed Cardano wallets (Nami, Eternl, Lace)

- **Payout Transaction**: Receives `recipientAddress`, `amountLovelace`, `claimMetadata`. Builds a MeshSDK `Transaction`, attaches on-chain metadata under label 674 (CIP-20) including: claim_id, user_id, amount_ada, ml_status, patient name, hashed_user_id, smart_contract address, timestamp. Signs with treasury wallet, submits via Blockfrost.  → User picks wallet → CIP-30 API call: window.cardano[wallet].enable()

  → Gets wallet address (addr_test1...)

- **Smart Contract Monitoring**: The compiled Aiken smart contract code is embedded. The script address is resolved and its UTXOs are monitored via Blockfrost for balance reporting. However, **direct script spending is disabled** due to a known MeshSDK v1 bug with Plutus V3 CBOR serialization (`MalformedScriptWitnesses`). Payouts use the treasury wallet directly instead.  → Frontend calls: GET /api/users/{wallet_address}

  → If wallet exists: returns user profile + all claims

- **Transaction Details**: Fetches full transaction info from Blockfrost including block height, slot, confirmations, fees, outputs, and CIP-20 metadata.  → If wallet is NEW: auto-registers user with default profile

     - Name: "User_{last6chars}" (e.g. "User_k3dq8w")

- **Timeout Protection**: All MeshSDK async calls are wrapped with `withTimeout()` to prevent hanging.     - Random age/gender, 1-year expiry, ₳50 premium

     - Profile setup modal opens → user enters: name, age, gender

---     - Frontend calls: PUT /api/users/{wallet}/profile → saves to DB

  → Frontend stores userData, shows dashboard

### `automation-service/` — Go Payout Automation  → Payouts go directly to the wallet the user connected with

```

| File | Lines | What It Does |

|------|-------|-------------|### Flow 2: Claim Submission (ML Only)

| **`database.go`** | 214 | PostgreSQL connection via `lib/pq`. Main function with 60-second polling ticker. Queries `claims WHERE payout_status = 'trigger' AND ml_status = 'genuine'`. Uses `COALESCE(payout_address, wallet_address)` so custom payout addresses work. Updates claim with `tx_hash` after successful transaction. Also tracks blockchain transaction confirmations. |```

| **`blockchain.go`** | 244 | HTTP client calling the Node.js service at `http://127.0.0.1:3001/api/payout-transaction`. Converts ADA to lovelace, builds metadata payload, handles response. Also stores blockchain transactions and periodically syncs `block_height` to claims table. |User fills 3-step form: Hospital Stay → Diagnosis & Billing → Documents

| **`crypto.go`** | 27 | `HashUserID(name, email)` — Creates Blake2b-256 hash of `(name + email)` for privacy-preserving public payout records. Falls back to SHA-256. |  → Frontend calls: POST /api/predict

| **`go.mod`** | — | Dependencies: blockfrost-go, godotenv, lib/pq, golang.org/x/crypto |     Body: { user_id, amount_billed, diagnosis }

  → Python fetches user age/gender from DB (auto-filled, not user-input)

#### Processing Flow:  → model_loader.py preprocesses:

1. `main()` starts, loads `.env`, connects to PostgreSQL     - One-Hot encodes: Gender, Diagnosis

2. Every 60 seconds: queries for `payout_status = 'trigger'` claims     - Adds StayDuration = 1 (default)

3. For each claim: hashes user ID → calls blockchain service → updates DB with tx_hash → inserts into `public_payouts`     - Aligns to 13 training features

4. Also updates transaction confirmations for pending blockchain transactions  → Gradient Boosting model predicts: [0=genuine, 1=fraud]

  → Confidence threshold: if genuine but confidence < 90% → rejected

---  → Creates new claim record in PostgreSQL

  → Returns: { claim_id, prediction_label, confidence, message }

### `aiken-contracts/` — Cardano Smart Contract```



| File | What It Does |### Flow 3: Image Verification (GPT-4o Vision)

|------|-------------|```

| **`validators/insurance_gatekeeper.ak`** | Aiken smart contract (Plutus V3). Enforces two on-chain rules: (1) transaction must be signed by the treasury wallet (hardcoded PKH), (2) datum must contain non-empty `hashed_user_id` (Blake2b-256). |If user uploads prescription + receipt images:

| **`aiken.toml`** | Project config: name, version, stdlib dependency |  → Frontend calls: POST /api/verify-images (multipart/form-data)

     Body: { claim_id, prescription_image, receipt_image }

The validator uses a custom `InsuranceDatum` type containing `hashed_user_id: ByteArray` for privacy. The compiled CBOR code is embedded in `app.ts` and the script address is resolved at startup. While the contract is compiled and deployed, **spending from the script address is not used** in the current version due to MeshSDK v1 limitations with Plutus V3 serialization.  → Python saves to temp files

  → prescription_verifier.py:

---     1. GPT-4o Vision extracts text from prescription image

     2. GPT-4o extracts medicine names from OCR text

### `client/` — Vue 3 Frontend     3. GPT-4o Vision extracts text from receipt image

     4. GPT-4o extracts product names from receipt text

| File | Lines | What It Does |     5. GPT-4o compares medicine lists (AI-powered fuzzy matching)

|------|-------|-------------|     6. If unprescribed items found → re-checks prescription image

| **`src/App.vue`** | 513 | Root component. Hero section (before connect), wallet info card, dashboard stats (Total/Approved/Rejected/Pending), quick actions (Submit Claim, View History), claim form toggle, profile setup modal for new users, filtered claims modal. Computed `claimStats` checks both `ml_status` and `images`. |     7. Returns: match_percentage (0-100%)

| **`src/api.js`** | 103 | Axios HTTP client. Functions: `healthCheck`, `getUserByWallet`, `submitClaim`, `triggerPayout`, `verifyImages`, `getModelInfo`, `updateProfile`. Base URL defaults to `/api` (proxied by Nginx). |  → Combined score = (ML confidence% + Image score%) / 2

| **`src/main.js`** | — | Vue app bootstrap with vue3-toastify |  → If combined ≥ 80% → claim stays genuine

| **`src/style.css`** | — | TailwindCSS imports + custom component classes (`.btn-primary`, `.badge-success`, `.input-base`, etc.) |  → If combined < 80% → claim.ml_status changed to 'fake'

| **`src/composables/useToast.js`** | 59 | Toast notification composable (success, error, info, warning) wrapping vue3-toastify |  → Updates claim record in DB with image_score, images status

```

#### Components:

### Flow 4: Payout Trigger & Execution

| Component | Lines | What It Does |```

|-----------|-------|-------------|User clicks "Claim Amount" on an approved claim

| **`NavBar.vue`** | 50 | Fixed navbar with HealthTrust logo, "Preprod Testnet" badge, WalletSelector |  → Frontend calls: PUT /api/claims/{id}/trigger-payout

| **`WalletSelector.vue`** | 473 | CIP-30 wallet integration. Detects Nami, Lace, Eternl browser extensions. Connects wallet, gets bech32 address via MeshSDK `BrowserWallet`. Emits address + wallet name to parent. Auto-disconnects on page leave. |     Body: { payout_address: "addr_test1..." } (optional, defaults to user's wallet)

| **`ClaimForm.vue`** | 653 | Multi-step claim form (3 steps): (1) Hospital stay details — admission/discharge dates, diagnosis, amount, (2) Document upload — prescription + receipt images, (3) Review & submit. Validates amount range, shows ML result with confidence, triggers image verification. |  → Python sets claim.payout_status = 'trigger' in DB

| **`ClaimsList.vue`** | 319 | Displays user's claims as cards. Each card shows: claim ID, amount, diagnosis, three status badges (ML Status, Image Status, Payout Status). Footer shows contextual action: "Rejected — AI Fraud Detection", "Rejected — Document Verification Failed", "Rejected — AI & Document Verification", "Claim Amount" button, "Processing payout...", or "View Transaction". Supports filtering by `filterType` prop (total/approved/rejected/pending). |

| **`StatusCard.vue`** | 152 | Dashboard stat card. Props: title, count, icon, variant, tooltip. Clickable to filter claims. |  [60 seconds later...]

| **`ActionCard.vue`** | 131 | Quick action card with icon, title, description, slot for buttons. |

| **`RecentActivity.vue`** | 268 | Landing page component (shown before wallet connect). Fetches `/recent-activity` API. Shows approved claims with blue CardanoScan links, rejected claims with red "Claim rejected — no payout" label. Auto-refreshes on mount. |  → Go automation service (database.go) polls DB:

| **`TransactionDetailsModal.vue`** | 351 | Fetches full transaction details from `/service/api/transaction/:txHash`. Displays: TX hash (copyable), block height, slot, confirmations, fees, amount, all CIP-20 metadata fields, CardanoScan link. |     SELECT claims WHERE payout_status = 'trigger' AND ml_status = 'genuine'

| **`BaseModal.vue`** | — | Reusable modal wrapper with title, body slot, backdrop, transitions |  → For each claim:

     1. crypto.go: HashUserID(name, email) → Blake2b-256 hash

#### Frontend Config:     2. blockchain.go: Build PayoutRequest

        - recipientAddress = user's wallet

| File | Purpose |        - amountLovelace = amount_billed × 1,000,000

|------|---------|        - hashedUserId = Blake2b hash

| `index.html` | SPA entry, loads `/src/main.js` |        - claimMetadata = { claim_id, user_id, amount, ml_status, patient_name, ... }

| `package.json` | Vue 3, @meshsdk/core, axios, vue3-toastify, TailwindCSS, Vite |     3. HTTP POST to Node.js: http://127.0.0.1:3001/api/payout-transaction

| `vite.config.js` | Dev server proxy: `/api` → `http://localhost:8000`, `/service` → `http://localhost:3001` |     4. app.ts builds Cardano transaction:

| `tailwind.config.js` | Custom colors: main-blue, main-green, accent-orange, success-green, danger-red, etc. |        - tx.sendLovelace(recipient, amount)

| `postcss.config.js` | TailwindCSS PostCSS plugin |        - tx.setMetadata(674, { msg, claim_id, user_id, hashed_user_id, smart_contract, ... })

        - tx.build() → signs with treasury mnemonic → submits to network

---     5. Returns txHash to Go

     6. Go updates DB: claim.payout_status = 'completed', claim.tx_hash = txHash

### `database/` — PostgreSQL Schema & Migrations     7. Go inserts into public_payouts table (privacy-preserving)

     8. Go inserts into blockchain_transactions table

| File | What It Does |     9. Go periodically updates confirmations from Blockfrost

|------|-------------|```

| **`schema.sql`** | Core schema: `users` (wallet holders), `claims` (with ML status, image verification, payout tracking), `public_payouts` (privacy-preserving public record with Blake2b-256 hashed user IDs). Includes CHECK constraints, indexes, and `updated_at` triggers. |

| **`seed.sql`** | Sample test users (Alice, Bob, Carol) with example Preprod wallet addresses |### Flow 5: Transaction Viewing

| **`migrations/003_blockchain_transactions.sql`** | Adds `blockchain_transactions` table: tx_hash, block info, confirmations, fees, metadata (JSONB), explorer URL |```

| **`migrations/004_add_payout_date.sql`** | Adds `payout_date` column + `claim_transactions` view joining claims with blockchain data |User clicks "View Transaction" on a completed claim

| **`migrations/005_add_image_verification.sql`** | Adds `prescription_image`, `receipt_image` (BYTEA), `images` (VARCHAR) columns |  → TransactionDetailsModal.vue opens

  → Frontend calls: GET /service/api/transaction/{txHash}

---  → Node.js fetches from Blockfrost: tx details, metadata, UTXOs, latest block

  → Returns: block_height, slot, confirmations, metadata (label 674), fees, explorer URL

### `data/` — Training Data  → Modal displays all blockchain data + link to CardanoScan

```

| File | What It Does |

|------|-------------|---

| **`healthcare_claims.csv`** | 20,000-row synthetic dataset. Columns: Patient ID, Age, Gender, Date Admitted, Date Discharged, Diagnosis, Amount Billed, Fraud Type. 8 diagnoses: Pregnancy, Hypertension, Diabetes, Pneumonia, Gastroenteritis, Cesarean Section, Cataract Surgery, Other. Fraud types: No Fraud, Phantom Billing, Upcoding, etc. |

## 5. Directory Structure & File-by-File Breakdown

---

### 5.1 Root Files

### `treasury-wallet/` — Wallet Generation Scripts

| File | Purpose |

| File | What It Does ||------|---------|

|------|-------------|| **`.env`** | Environment variables: `DATABASE_URL`, `BLOCKFROST_API_KEY`, `TREASURY_ADDRESS`, `TREASURY_MNEMONIC`. Loaded by all services. |

| **`generate-wallet.js`** | Generates treasury wallet: creates 24-word mnemonic via `MeshWallet.brew()`, derives Preprod address, saves to files, updates `.env` || **`.gitignore`** | Ignores: `node_modules/`, `venv/`, `__pycache__/`, `.env`, `*.mnemonic`, `dist/`, `*.pkl` patterns, IDE files, OS files. |

| **`generate-user-wallets.js`** | Generates 3 test user wallets (Alice, Bob, Carol), saves mnemonics + addresses to `users/` subdirectories, generates SQL update script || **`README.md`** | Project overview with architecture diagram, setup guide, API docs, tech stack, Aiken contract section. |

| **`update_user_wallets.sql`** | SQL to update user table with generated wallet addresses || **`start.sh`** | **Master control script** (265 lines). Commands: `start` (all + ngrok), `local` (no ngrok), `stop`, `restart`, `status`. Manages Nginx, Python ML, Node.js blockchain, Go automation, ngrok. Color-coded output, health checks, PID tracking, log file paths. |

| **`package.json`** | Dependencies: @meshsdk/core |

| **`users/*/mnemonic.txt`** | 24-word Cardano mnemonics for test users (Preprod testnet — no real funds) |---

| **`users/*/address.txt`** | Bech32 Preprod testnet addresses for test users |

### 5.2 Frontend — `client/`

---

**Build**: `npm run build` → outputs to `client/dist/` (served by Nginx)

### `deploy/` — Server Deployment Scripts

| File | Lines | Purpose |

| File | What It Does ||------|-------|---------|

|------|-------------|| **`package.json`** | 34 | Dependencies: Vue 3.5, MeshSDK 1.9-beta, Axios, Heroicons, vue3-toastify. DevDeps: Vite 7.2, TailwindCSS, PostCSS, vite-plugin-node-polyfills. |

| **`setup-server.sh`** | Fresh Ubuntu 22.04 setup: installs Node.js 22, Python 3, Go 1.22, PostgreSQL, Nginx, UFW firewall || **`vite.config.js`** | 15 | Vite config with Vue plugin + `nodePolyfills` plugin (provides `crypto`, `stream`, `buffer`, `process` for MeshSDK to work in browser). |

| **`setup-database.sh`** | Creates PostgreSQL user + database, runs schema + migrations || **`tailwind.config.js`** | 40 | Custom color palette: `main-blue` (#264a70), `main-green` (#11998e), `accent-orange` (#e97d30), plus `secondary-blue`, `light-gray`, `dark-gray`, `success-green`, `danger-red`, `warning-yellow`. Inter font family. Custom shadow tokens. Dark mode via `class`. |

| **`setup-services.sh`** | Sets up all three services: Python venv + deps, Node.js `npm install`, Go binary compilation || **`postcss.config.js`** | — | Standard TailwindCSS + autoprefixer PostCSS config. |

| **`setup-nginx.sh`** | Generates Nginx config with reverse proxy rules, enables site || **`vercel.json`** | — | SPA rewrite rule for Vercel deployment (fallback to `index.html`). |

| **`healthtrust-ml.service`** | systemd unit — FastAPI on port 8000 (2 Uvicorn workers) || **`index.html`** | — | Entry HTML with `<div id="app">`, loads `main.js`. |

| **`healthtrust-blockchain.service`** | systemd unit — Node.js Express on port 3001 |

| **`healthtrust-go.service`** | systemd unit — Compiled Go binary |#### `src/` — Source Files

| **`healthtrust.nginx`** | Production Nginx config with HTTPS/TLS, rate limiting, security headers |

| **`healthtrust-local.nginx`** | Local development Nginx config (HTTP only) || File | Lines | Purpose |

|------|-------|---------|

---| **`main.js`** | 7 | App entry point. Imports Vue, global CSS, toast CSS. Mounts `<App>` to `#app`. |

| **`App.vue`** | 450+ | **Root component & layout controller**. Manages: wallet connection state, user data fetching, claim stats computation. Shows hero section (pre-connect) or dashboard (post-connect). Contains: NavBar, RecentActivity (public), StatusCards (4 stats), ActionCards (submit/history), ClaimForm (inline toggle), ClaimsList (modal), footer. **Interactive dashboard**: clicking any StatusCard (Total Claims, Approved, Rejected, Pending Payout) opens a filtered claims modal showing only the matching claims. Auto-refreshes user data every 30s while connected. Handles payout trigger with toast notifications. |

## 5. Database Schema| **`api.js`** | 95 | **Axios API client**. Base URL: `/api` (proxied by Nginx to Python :8000). Methods: `healthCheck()`, `getUserByWallet(address)`, `submitClaim(data)`, `triggerPayout(claimId, walletAddress)`, `verifyImages(claimId, prescriptionFile, receiptFile)`, `getModelInfo()`. 10s default timeout, 60s for image verification. Error interceptor logs to console. |

| **`style.css`** | 210 | **Global styles**. Imports Inter font from Google Fonts. Tailwind layers: `@tailwind base/components/utilities`. CSS variables for colors. Components: `.glass` (glassmorphism), `.card-base`, `.btn-primary/success/danger/secondary`, `.input-base`, `.badge-*` variants. Utilities: `.animate-float`, `.text-gradient`, `.scrollbar-thin`. Keyframes: `spin`, `float`, `pulse`. Toast notification overrides. |

```sql

┌─────────────────────────────────────────┐#### `src/components/` — Vue Components

│ users                                    │

├─────────────────────────────────────────┤| Component | Lines | Purpose |

│ id            SERIAL PRIMARY KEY         │|-----------|-------|---------|

│ name          VARCHAR(255)               │| **`NavBar.vue`** | 48 | Fixed top navigation bar with glassmorphism (`bg-white/80 backdrop-blur-xl`). HealthTrust logo with gradient glow effect. "Preprod Testnet" badge (desktop). Embeds `WalletSelector`. Emits: `wallet-connected`, `disconnect`. |

│ email         VARCHAR(255) UNIQUE        │| **`WalletSelector.vue`** | 451 | **Cardano wallet connection manager**. Detects installed wallets via `window.cardano` (CIP-30). Supports: Nami, Eternl, Lace, Flint, Typhon, Yoroi, GeroWallet, NuFi. Shows modal with 3-column wallet grid. On connect: enables wallet → gets used addresses → gets change address → resolves to Bech32 → emits address + wallet instance. Disconnect clears localStorage. Help text with wallet download links. |

│ wallet_address VARCHAR(255) UNIQUE       │| **`ClaimForm.vue`** | 653 | **3-step claim submission wizard**. Step 1: Hospital stay dates (admission/discharge, auto-computes days). Step 2: Diagnosis dropdown (8 options matching ML model features) + amount billed in ADA. Step 3: Optional document upload (receipt + prescription, max 10MB each). Summary card before submit. On submit: calls `/predict` → if images uploaded, calls `/verify-images` → shows result with ML confidence %, image score %, combined score %. Cancel button aborts request. Color-coded result: green (approved) / red (rejected). |

│ age           INTEGER                    │| **`ClaimsList.vue`** | 292 | **Claims history list**. Displays all user claims as cards in a **single-column layout**. Supports `filterLabel` prop to show only "Total"/"Approved"/"Rejected"/"Pending Payout" claims (used by interactive dashboard stats). Each card shows: claim ID, amount (ADA), date, diagnosis, age, gender. Status badges: ML status (genuine/fake/pending), image verification status, payout status. Actions: "Claim Amount" (trigger payout), "View Transaction" (opens TransactionDetailsModal), "Processing..." spinner, "Rejected" indicator. Fake claims warning banner at bottom. Refresh button. |

│ gender        VARCHAR(10)                │| **`StatusCard.vue`** | 152 | **Interactive dashboard stat card**. Props: title, count, description, tooltip, icon, variant. Icons from Heroicons: check, warning, error, clock, document. Color variants: success (green), warning (yellow), danger (red), info (blue). **Clickable** — emits `click` event, used by App.vue to open filtered claims modal. Hover: cursor pointer, ring highlight, scale effect on icon. |

│ expiry_date   DATE                       │| **`ActionCard.vue`** | 131 | **Quick action card**. Props: title, description, icon, variant. Icons: upload, view, transfer, check, clipboard (Heroicons). Top accent bar colored by variant. Hover shadow transition. Slot: `#actions` for custom buttons. |

│ premium       DECIMAL(10,2)              │| **`RecentActivity.vue`** | 261 | **Public activity feed** (shown before wallet connect). Fetches `GET /api/recent-activity?limit=5`. Displays completed claims with: approved/rejected status, amount, diagnosis, transaction hash (truncated), copy button. Click opens TransactionDetailsModal. "View all on CardanoScan" link. Auto-fetches on mount. Loading spinner, error state, empty state. |

│ created_at    TIMESTAMP                  │| **`TransactionDetailsModal.vue`** | 351 | **Blockchain transaction detail viewer**. Shows: TX hash (copyable), block height, epoch/slot, claim metadata (ID, amount, age, gender, diagnosis, timestamp), "Verified on Cardano Blockchain" notice, CardanoScan explorer link. Fetches additional data from `/service/api/transaction/{txHash}` for block confirmations. |

│ updated_at    TIMESTAMP                  │| **`BaseModal.vue`** | 105 | **Reusable modal component**. Teleported to `<body>`. Props: `modelValue` (v-model), `title`. Gradient header (blue→green), scrollable body, optional footer. Close on backdrop click or X button. Prevents body scroll when open. Slide-in animation. |

└─────────────┬───────────────────────────┘| **`HelloWorld.vue`** | — | Vue boilerplate (unused). |

              │ 1:N

┌─────────────▼───────────────────────────┐#### `src/composables/`

│ claims                                   │

├─────────────────────────────────────────┤| File | Lines | Purpose |

│ id            SERIAL PRIMARY KEY         │|------|-------|---------|

│ user_id       INTEGER FK → users(id)     │| **`useToast.js`** | 59 | Composable wrapping `vue3-toastify`. Exports: `showSuccess()`, `showError()`, `showInfo()`, `showWarning()`. All positioned top-right with 3-4s auto-close, progress bar, draggable. |

│ amount_billed DECIMAL(10,2)              │

│ age           INTEGER (CHECK 0-150)      │---

│ gender        VARCHAR(10) (Male/Female)  │

│ diagnosis     VARCHAR(100)               │### 5.3 ML Service — `ml-service/`

│ ml_status     VARCHAR(20)                │  ← genuine | fake | pending

│ confidence    DECIMAL(5,4)               │  ← 0.0000 – 1.0000**Runtime**: Python 3.10 + FastAPI + Uvicorn on port 8000 (bound to 127.0.0.1)

│ images        VARCHAR(20)                │  ← genuine | fake | NULL

│ image_score   DECIMAL(5,2)               │  ← 0.00 – 100.00The ML service is structured with a clear separation between **ML model logic** and **AI API logic**:

│ payout_status VARCHAR(20)                │  ← pending | trigger | completed | rejected

│ payout_address VARCHAR(255)              │  ← optional custom payout address- **`model_loader.py`** → All **Machine Learning** code (scikit-learn Gradient Boosting model)

│ tx_hash       VARCHAR(255)               │  ← Cardano transaction hash- **`prescription_verifier.py`** → All **AI API** code (OpenAI GPT-4o Vision API)

│ block_height  INTEGER                    │

│ slot          INTEGER                    │| File | Lines | Purpose |

│ payout_date   TIMESTAMP                  │|------|-------|---------|

│ created_at    TIMESTAMP                  │| **`main.py`** | ~60 | **FastAPI application entry point**. Creates the FastAPI app instance, configures CORS middleware (all origins), registers the API router from `routes.py`, runs the startup event (initializes DB tables + warms up ML model). Clean separation — no endpoint logic here, only app setup and lifecycle. |

│ updated_at    TIMESTAMP (auto-trigger)   │| **`routes.py`** | ~435 | **All API endpoint handlers**. Defines an `APIRouter` with all endpoints: `GET /` (health check with model stats), `POST /predict` (claim submission + ML prediction with detailed terminal logging), `GET /users/{wallet_address}` (user profile + claims), `PUT /claims/{id}/trigger-payout` (set payout_status to 'trigger'), `GET /model/info` (model metadata + top features), `GET /recent-activity` (public feed of completed claims), `POST /verify-images` (GPT-4o prescription vs receipt verification with combined scoring). Imports model_loader for ML and prescription_verifier for AI. |

└─────────────────────────────────────────┘| **`model_loader.py`** | 203 | **🤖 ML Model File** — Contains all Machine Learning logic. Class `FraudDetectionModel` loads 4 pickle artifacts from `models/` directory: `best_model.pkl` (Gradient Boosting), `scaler.pkl` (StandardScaler), `feature_names.pkl` (13 feature columns), `metadata.pkl` (accuracy, F1, training date). `preprocess_input()`: creates DataFrame, one-hot encodes Gender + Diagnosis, aligns to exact training feature order (13 columns), fills missing with 0. `predict()`: runs model, gets probability, applies 90% confidence threshold (if genuine but < 90% confidence → rejected as 'fake' with reason 'low_confidence'). `get_feature_importance()`: returns top N features from Gradient Boosting's `feature_importances_`. Singleton pattern via `get_model()`. |

| **`prescription_verifier.py`** | 620 | **🧠 AI API File** — Contains all OpenAI GPT-4o Vision API logic. Flow: (1) `extract_medicines_from_prescription()` — sends prescription image to GPT-4o Vision for OCR, then extracts medicine names from OCR text. (2) `extract_medicines_from_receipt()` — same for pharmacy receipt. (3) `ai_compare_medicines()` — detailed GPT-4o prompt comparing prescribed vs purchased medicines with fuzzy matching, brand/generic equivalence, OCR error tolerance, handwriting interpretation. (4) `recheck_prescription_for_missing_items()` — double-checks prescription for any items found on receipt but missed in first pass. Supports: JPG, JPEG, PNG, PDF (via pdf2image). Returns: `(is_genuine, match_percentage)`. Threshold: ≥80% match = genuine. |

┌─────────────────────────────────────────┐| **`database.py`** | 110 | **SQLAlchemy ORM models**. `User`: id, name, email, wallet_address, age, gender, expiry_date, premium. `Claim`: id, user_id, amount_billed, age, gender, diagnosis, ml_status, confidence, images, image_score, payout_status, payout_address, tx_hash, block_height, slot. `PublicPayout`: id, hashed_user_id, amount, tx_hash. Constraints: age 0-150, gender Male/Female, ml_status genuine/fake/pending, payout_status pending/trigger/completed. Relationships: User→Claims (one-to-many). `get_db()` dependency, `init_db()` creates tables. Connection string from `.env`. |

│ public_payouts (privacy-preserving)      │| **`export_model.py`** | 140 | **Model training & export script**. Loads `data/healthcare_claims.csv` (20,000 rows). Feature engineering: FraudStatus binary target, StayDuration from dates. Trains 7 models: Logistic Regression, SVC, KNN, Decision Tree, Random Forest, Gradient Boosting, Voting Ensemble. Selects best by F1 score (Gradient Boosting wins). Exports to `models/`: `best_model.pkl`, `scaler.pkl`, `feature_names.pkl`, `metadata.pkl`. |

├─────────────────────────────────────────┤| **`requirements.txt`** | 13 | Python dependencies: fastapi, uvicorn, pydantic, sqlalchemy, psycopg2-binary, python-dotenv, scikit-learn, pandas, numpy, python-multipart, openai, pdf2image, pillow. |

│ id              SERIAL PRIMARY KEY       │| **`setup.sh`** | — | Bash script to create venv and install requirements. |

│ hashed_user_id  VARCHAR(64)              │  ← Blake2b-256(name + email)| **`start-ml-service.sh`** | — | Bash script to activate venv and run uvicorn. |

│ amount          DECIMAL(10,2)            │

│ tx_hash         VARCHAR(255) UNIQUE      │#### `models/` — Trained Model Artifacts

│ timestamp       TIMESTAMP                │

└─────────────────────────────────────────┘| File | Purpose |

|------|---------|

┌─────────────────────────────────────────┐| **`best_model.pkl`** | Serialized Gradient Boosting classifier (scikit-learn) |

│ blockchain_transactions                  │| **`scaler.pkl`** | StandardScaler fitted on training data (not used by Gradient Boosting but exported for other models) |

├─────────────────────────────────────────┤| **`feature_names.pkl`** | List of 13 feature column names after one-hot encoding |

│ tx_hash          VARCHAR(64) PK          │| **`metadata.pkl`** | Dictionary: model_name, accuracy (0.863), f1_score, n_features (13), training_date |

│ claim_id         INTEGER FK → claims(id) │

│ block_height     BIGINT                  │---

│ block_hash       VARCHAR(64)             │

│ block_timestamp  TIMESTAMP               │### 5.4 Blockchain Service — `server/blockchain-service/`

│ slot             BIGINT                  │

│ confirmations    INTEGER                 │**Runtime**: Node.js 22 + Express + TypeScript on port 3001 (bound to 127.0.0.1)

│ status           VARCHAR(20)             │  ← pending | confirmed | failed

│ size             INTEGER (bytes)         │| File | Lines | Purpose |

│ gas_fees         BIGINT (lovelace)       │|------|-------|---------|

│ total_output     BIGINT (lovelace)       │| **`src/app.ts`** | ~385 | **Express server with Cardano blockchain integration**. Initializes: BlockfrostProvider (Preprod), MeshWallet (from treasury mnemonic), Aiken compiled code constant, script address (for monitoring). `withTimeout()` helper wraps all MeshSDK calls to prevent silent hangs. `getScriptUtxos()` fetches UTXOs at smart contract address via Blockfrost REST API. `totalLovelace()` sums lovelace across UTXOs. **Endpoints**: `GET /health` (wallet + script balances, UTxO counts), `GET /api/balance` (detailed balance breakdown), `GET /api/epoch` (current epoch/slot from Blockfrost), `POST /api/payout-transaction` (builds Transaction, attaches CIP-20 metadata label 674, signs with treasury key, submits to Cardano), `GET /api/transaction/:txHash` (fetches full TX details + metadata + confirmations from Blockfrost). |

│ network          VARCHAR(20)             │| **`package.json`** | 31 | Dependencies: @meshsdk/core 1.7.8+, express, dotenv, cors. DevDeps: TypeScript 5.3, ts-node, nodemon, @types/express, @types/cors, @types/node. Scripts: `dev` (nodemon), `start` (ts-node), `build` (tsc). |

│ metadata         JSONB                   │| **`tsconfig.json`** | 23 | TypeScript config: ES2020 target, commonjs modules, strict mode, esModuleInterop, resolveJsonModule. Output: `dist/`. |

│ explorer_url     TEXT                    │| **`Procfile`** | — | `web: npx ts-node src/app.ts` (for Railway/Heroku deployment). |

└─────────────────────────────────────────┘| **`railway.json`** | — | Railway deployment config. |

```| **`generate-alice-wallet.js`** | — | Utility to generate a test wallet for Alice. |



---#### Payout Transaction Metadata (CIP-20, label 674)



## 6. ML PipelineEvery payout transaction includes this on-chain metadata:



### Training (`export_model.py`)```json

{

1. **Load** `data/healthcare_claims.csv` (20,000 rows, 8 columns)  "msg": ["HealthTrust Insurance Payout"],

2. **Feature Engineering:**  "claim_id": 75,

   - Binary target: `FraudStatus = 1` if `Fraud Type != 'No Fraud'`  "user_id": 1,

   - Compute `StayDuration = Date Discharged - Date Admitted` (days)  "amount_ada": 15.50,

   - Drop: Patient ID, Date Admitted, Date Discharged, Fraud Type  "ml_status": "genuine",

3. **Split:** 75% train / 25% test, stratified  "claim_type": "healthcare",

4. **One-Hot Encoding:** Gender (Male → dropped, Female → 1), Diagnosis (7 categories → 6 binary columns) → 13 total features  "patient": "Alice Johnson",

5. **Feature Scaling:** StandardScaler (used only for SVC and KNN)  "hashed_user_id": "a3b4c5d6...",

6. **Train 7 models:**  "smart_contract": "addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k",

   - Logistic Regression (class_weight='balanced')  "approved_at": "2026-02-21T18:30:00.000Z",

   - SVC (class_weight='balanced', probability=True)  "network": "preprod"

   - K-Nearest Neighbors (k=30)}

   - Decision Tree (class_weight='balanced')```

   - Random Forest (100 trees, class_weight='balanced')

   - Gradient Boosting (50 trees) ← **Best performer**---

   - Voting Classifier (RF + GB + DT)

7. **Select best** by F1 score → Gradient Boosting (86.3% accuracy, 0.80 F1)### 5.5 Automation Service — `automation-service/`

8. **Export** to `models/`: `best_model.pkl`, `scaler.pkl`, `feature_names.pkl`, `metadata.pkl`

**Runtime**: Go 1.21+ (compiled binary, runs as background daemon)

### Inference (`model_loader.py`)

| File | Lines | Purpose |

1. Input: `amount_billed`, `age`, `gender`, `diagnosis`|------|-------|---------|

2. Create DataFrame → one-hot encode → align to 13 training features (fill missing with 0)| **`database.go`** | 214 | **Main entry point + DB operations**. `main()`: loads `.env`, connects to PostgreSQL, starts 60-second ticker. `processPayouts()`: queries `claims WHERE payout_status = 'trigger' AND ml_status = 'genuine'` (also checks `payout_address` for custom recipient). For each claim: hashes user ID, calls `SubmitTransaction()`, updates claim status to 'completed', inserts into `public_payouts` table. `GetPendingPayouts()` uses `COALESCE(c.payout_address, u.wallet_address)` to support custom payout addresses. |

3. Predict with Gradient Boosting (tree-based → no scaling needed)| **`blockchain.go`** | 244 | **Blockchain service client**. `SubmitTransaction()`: converts ADA to lovelace, builds JSON payload with claim metadata, POSTs to `http://127.0.0.1:3001/api/payout-transaction` (120s timeout). Parses response for txHash. `StoreBlockchainTransaction()`: inserts into `blockchain_transactions` table. `UpdateTransactionConfirmations()`: polls pending transactions via `GET /api/transaction/{txHash}`, updates confirmations, block_height, slot, fees in DB. `SyncBlockHeightToClaim()`: copies block_height to claims table. |

4. **Confidence Threshold: 90%** — if model predicts "genuine" but confidence < 90%, flip to "fake" (low_confidence rejection)| **`crypto.go`** | 27 | **Privacy hashing**. `HashUserID(name, email)`: concatenates name+email, computes Blake2b-256 hash, returns hex string. Fallback to SHA-256 if Blake2b fails. This hash goes on-chain in metadata for privacy-preserving public records. |

5. Return: `prediction` (0/1), `prediction_label` (genuine/fake), `confidence` (0.0–1.0)| **`go.mod`** | 16 | Module: `cardano-insurance-automation`. Dependencies: blockfrost-go, godotenv, lib/pq, golang.org/x/crypto. |



------



## 7. Image Verification System### 5.6 Smart Contract — `aiken-contracts/`



### Pipeline (`prescription_verifier.py`)**Language**: Aiken 1.1.19, targeting Plutus V3 (Conway era)



**Stage 1 — Prescription OCR (2 GPT-4o calls):**| File | Lines | Purpose |

1. GPT-4o Vision reads the prescription image (handwritten or printed)|------|-------|---------|

2. Second GPT-4o call extracts medicine names from the OCR text| **`validators/insurance_gatekeeper.ak`** | 58 | **On-chain Plutus V3 validator**. Types: `InsuranceDatum { hashed_user_id: ByteArray }`, `InsuranceRedeemer { Void }`. Treasury PKH hardcoded: `9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057`. Validation logic: (1) Transaction MUST be signed by treasury PKH (checked via `tx.extra_signatories`), (2) Datum must be present with non-empty `hashed_user_id`. Both conditions must pass. `else(_)` handler fails all other purposes. |

| **`aiken.toml`** | 20 | Project config: name `cardano-insurance/insurance-gatekeeper`, compiler v1.1.19, plutus v3, Apache-2.0 license. Dependency: `aiken-lang/stdlib` v3.0.0. |

**Stage 2 — Receipt OCR (2 GPT-4o calls):**| **`build/`** | — | Compiled output from `aiken build`. Contains `plutus.json` with CBOR-encoded validator, and `packages/` with stdlib source. |

1. GPT-4o Vision reads the pharmacy receipt image

2. Second GPT-4o call extracts product/medicine names#### Contract Status



**Stage 3 — AI Medicine Comparison (1 GPT-4o call):**| Property | Value |

- Compares prescription medicines against receipt medicines|----------|-------|

- Handles: spelling variations, brand/generic equivalents, OCR errors, abbreviations, handwriting misreads| Script Hash | `5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e` |

- Uses medical knowledge to match (e.g., "Augmentin" = "co-amoxiclav")| Script Address | `addr_test1wztz8zu9yyw372ren6tlyk5hgtjzm22st2c9dyz7s92cwxcz7cs3k` |

- Checks for UNPRESCRIBED items (receipt items not on prescription)| Locked Funds | 500 tADA (locked via manual transaction) |

- Returns per-medicine: MATCH/NO MATCH, confidence %, purchased_as name, reason| Spending | **Disabled** — MeshSDK v1 has a known bug with Plutus V3 CBOR serialization (`MalformedScriptWitnesses`). The contract is compiled, deployed, and monitored (balance shown in `/health` endpoint). Spending will be enabled when MeshSDK v2 releases. |



**Stage 4 — Re-check (1 GPT-4o call, conditional):**---

- If any unprescribed items found, re-examines the prescription image

- Acts as "second pair of eyes" for items that may have been missed in Stage 1### 5.7 Database — `database/`



### Scoring Logic| File | Lines | Purpose |

```|------|-------|---------|

image_score = (receipt_matched / total_receipt_items) × 100| **`schema.sql`** | 70 | **Core schema**. Creates tables: `users` (id, name, email, wallet_address, expiry_date, premium), `claims` (id, user_id, amount_billed, age, gender, diagnosis, ml_status, payout_status, tx_hash), `public_payouts` (hashed_user_id, amount, tx_hash). Indexes on wallet_address, user_id, payout_status, ml_status, tx_hash. `updated_at` trigger function. Comments on all tables/columns. |

combined_score = (ML_confidence% + image_score) / 2| **`seed.sql`** | 20 | **Initial test data**. Inserts 3 users: Alice Johnson, Bob Smith, Carol Williams with Preprod testnet wallet addresses, expiry dates, premiums. |

Verdict: combined_score ≥ 80% → genuine, else fake| **`migrations/003_blockchain_transactions.sql`** | 91 | Adds `blockchain_transactions` table: tx_hash (PK), claim_id (FK), block_height, block_hash, block_timestamp, slot, confirmations, status, size, gas_fees, total_output, network, metadata (JSONB), explorer_url. Adds tx_hash column to claims if missing. Creates `claim_transactions` view. |

```| **`migrations/004_add_payout_date.sql`** | 33 | Adds `payout_date` column to claims. Creates `claim_transactions` view joining claims with blockchain_transactions. |

| **`migrations/005_add_image_verification.sql`** | 16 | Adds to claims: `prescription_image` (BYTEA), `receipt_image` (BYTEA), `images` (VARCHAR — 'genuine' or 'fake'). |

Total GPT-4o calls per verification: 5–6 (2 prescription + 2 receipt + 1 comparison + 0–1 recheck)

---

---

### 5.8 Treasury Wallet — `treasury-wallet/`

## 8. Blockchain Integration

| File | Lines | Purpose |

### Transaction Structure (`app.ts`)|------|-------|---------|

| **`generate-wallet.js`** | 80 | **Treasury wallet generator**. Uses MeshSDK to `MeshWallet.brew()` a new 24-word mnemonic, creates wallet (networkId=0 for Preprod), gets change address. Saves `treasury.mnemonic` and `treasury.addr` files. Updates `../.env` with TREASURY_ADDRESS and TREASURY_MNEMONIC. Prints next steps (fund via faucet, verify on CardanoScan). |

Every payout is an ADA transaction on Cardano Preprod with:| **`generate-user-wallets.js`** | 100 | **Test user wallet generator**. Generates wallets for Alice, Bob, Carol. Saves mnemonics and addresses to `users/{name}/`. Generates `update_user_wallets.sql` to update DB. |

| **`update_user_wallets.sql`** | — | Generated SQL: `UPDATE users SET wallet_address = '...' WHERE id = N;` for each user. |

- **Sender:** Treasury wallet (24-word mnemonic, ~4000+ tADA)| **`treasury.addr`** | 1 | Treasury wallet Bech32 address. |

- **Recipient:** User's connected wallet address (or custom payout address)| **`treasury.mnemonic`** | 1 | Treasury 24-word mnemonic (gitignored). |

- **Amount:** Claim's `amount_billed` converted to lovelace (× 1,000,000)| **`TREASURY_WALLET.md`** | — | Documentation about the treasury wallet setup. |

- **Metadata (CIP-20, Label 674):**| **`package.json`** | — | Dependencies for wallet generation scripts (MeshSDK). |

  ```json| **`users/`** | — | Subdirectories for alice_johnson, bob_smith, carol_williams — each with `address.txt` and `mnemonic.txt`. |

  {

    "msg": ["HealthTrust Insurance Payout"],#### Treasury Wallet

    "claim_id": 5,

    "user_id": 4,| Property | Value |

    "amount_ada": 250.00,|----------|-------|

    "ml_status": "genuine",| Address | `addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78` |

    "claim_type": "healthcare",| PKH | `9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057` |

    "patient": "Alice Johnson",| Network | Cardano Preprod Testnet |

    "hashed_user_id": "9b9460c4...",| Mnemonic | 24 words (stored in `.env` and `treasury.mnemonic`, both gitignored) |

    "smart_contract": "addr_test1...",

    "approved_at": "2026-02-23T..."---

  }

  ```### 5.9 Deployment — `deploy/`



All metadata is permanently stored on-chain and viewable on CardanoScan.| File | Lines | Purpose |

|------|-------|---------|

### Wallet Infrastructure| **`healthtrust-local.nginx`** | 78 | **Nginx reverse proxy config** (currently active). Rate limiting: 10r/s for API, 30r/s general. Routes: `/` → `client/dist/` (Vue SPA with `try_files` fallback), `/api/*` → rewrite strip prefix → proxy to Python :8000, `/service/*` → rewrite strip prefix → proxy to Node.js :3001. 20MB body limit for image uploads. 120s proxy timeout for GPT-4o calls. |

| **`healthtrust.nginx`** | — | Production Nginx config (with TLS/SSL). |

- **Treasury:** Single wallet holding all funds, managed by MeshSDK| **`healthtrust-ml.service`** | 37 | systemd unit for ML service. Runs as `healthtrust` user. ExecStart: uvicorn with 2 workers. Security: NoNewPrivileges, ProtectSystem=strict, ProtectHome, PrivateTmp. Requires PostgreSQL. |

- **User wallets:** Connected via CIP-30 browser extensions (Nami, Lace, Eternl)| **`healthtrust-blockchain.service`** | 31 | systemd unit for blockchain service. ExecStart: `node -r ts-node/register src/app.ts`. Same security hardening. |

- **Address format:** Bech32 (`addr_test1...`) for Preprod testnet| **`healthtrust-go.service`** | 32 | systemd unit for Go automation. ExecStart: compiled binary. Requires PostgreSQL + blockchain service. |

- **3 pre-generated test wallets:** Alice, Bob, Carol — mnemonics in README| **`deploy.sh`** | — | Automated deployment script for production server setup. |



------



## 9. Smart Contract (Aiken)### 5.10 Data — `data/`



```aiken| File | Purpose |

validator insurance_gatekeeper {|------|---------|

  spend(datum, _redeemer, _own_ref, ctx) {| **`healthcare_claims.csv`** | **Training dataset**: 20,000 simulated healthcare insurance claims. Columns: Patient ID, Age, Gender, Date Admitted, Date Discharged, Diagnosis (Pregnancy, Hypertension, Diabetes, Pneumonia, Gastroenteritis, Cesarean Section, Cataract Surgery, Migraine), Amount Billed, Fraud Type (No Fraud, Phantom Billing, etc.). Used by `export_model.py` to train the ML model. |

    // Rule 1: Must be signed by treasury wallet| **`model_training.ipynb`** | **Jupyter Notebook**: Full ML training pipeline with exploratory data analysis, feature engineering, model comparison (7 models), evaluation metrics, confusion matrices, feature importance plots. Documents the research process. |

    let must_be_signed = list.has(ctx.extra_signatories, treasury_pkh)

    ---

    // Rule 2: Datum must have non-empty hashed_user_id

    let has_valid_datum = when datum is {## 6. Database Schema

      Some(d) -> d.hashed_user_id != ""

      None -> False**Database**: PostgreSQL 18, name: `HealthTrust`

    }

    ```

    must_be_signed && has_valid_datum┌─────────────────────────────┐     ┌─────────────────────────────────────────────┐

  }│          users              │     │                 claims                       │

}├─────────────────────────────┤     ├─────────────────────────────────────────────┤

```│ id          SERIAL PK       │←────│ user_id       INTEGER FK                    │

│ name        VARCHAR(255)    │     │ id            SERIAL PK                     │

- **Language:** Aiken (compiles to Plutus V3 CBOR)│ email       VARCHAR(255) UQ │     │ amount_billed DECIMAL(10,2)                 │

- **Datum Type:** `InsuranceDatum { hashed_user_id: ByteArray }` — Blake2b-256 hash for privacy│ wallet_address VARCHAR(255) │     │ age           INTEGER (1-150)               │

- **Treasury PKH:** `9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057`│ age         INTEGER         │     │ gender        VARCHAR(10) (Male/Female)     │

- **Script Address:** Resolved at runtime via `resolvePlutusScriptAddress()`│ gender      VARCHAR(10)     │     │ diagnosis     VARCHAR(100)                  │

- **Status:** Compiled and deployed, script address monitored for balance. Direct script spending disabled due to MeshSDK v1 bug with Plutus V3 CBOR (`MalformedScriptWitnesses`). Can be enabled when MeshSDK v2 ships.│ expiry_date DATE            │     │ ml_status     VARCHAR(20) (genuine/fake/pending) │

│ premium     DECIMAL(10,2)   │     │ confidence    DECIMAL(5,4) (0.0000-1.0000)  │

---│ created_at  TIMESTAMP       │     │ images        VARCHAR(20) (genuine/fake)    │

│ updated_at  TIMESTAMP       │     │ image_score   DECIMAL(5,2) (0-100)          │

## 10. Frontend Architecture└─────────────────────────────┘     │ payout_status VARCHAR(20) (pending/trigger/completed) │

                                    │ payout_address VARCHAR(255)                 │

### Wallet Connection Flow                                    │ tx_hash       VARCHAR(255)                  │

                                    │ block_height  INTEGER                       │

1. User clicks "Connect Wallet" → modal shows detected wallets (Nami, Lace, Eternl)                                    │ slot          INTEGER                       │

2. `BrowserWallet.enable(walletKey)` → CIP-30 connection                                    │ created_at    TIMESTAMP                     │

3. `getChangeAddress()` → bech32 address                                    │ updated_at    TIMESTAMP                     │

4. Call `GET /api/users/{address}` → if new wallet, auto-register user                                    └─────────────────────────────────────────────┘

5. If user name starts with `User_`, show profile setup modal

6. Dashboard renders with claims data┌─────────────────────────────┐     ┌─────────────────────────────────────────────┐

│      public_payouts         │     │         blockchain_transactions              │

### Claim Submission Flow├─────────────────────────────┤     ├─────────────────────────────────────────────┤

│ id          SERIAL PK       │     │ tx_hash        VARCHAR(64) PK               │

1. Step 1: Enter admission/discharge dates, select diagnosis, enter amount│ hashed_user_id VARCHAR(64)  │     │ claim_id       INTEGER FK → claims           │

2. Step 2 (optional): Upload prescription image + receipt image│ amount      DECIMAL(10,2)   │     │ block_height   BIGINT                       │

3. Step 3: Review all details│ tx_hash     VARCHAR(255) UQ │     │ block_hash     VARCHAR(64)                  │

4. Submit → `POST /api/predict` → ML result shown immediately│ timestamp   TIMESTAMP       │     │ block_timestamp TIMESTAMP                   │

5. If images uploaded → `POST /api/verify-images` → image result shown└─────────────────────────────┘     │ slot           BIGINT                       │

6. If approved → "Claim Amount" button → `PUT /api/claims/{id}/trigger-payout`                                    │ confirmations  INTEGER                      │

7. Dashboard updates in real-time                                    │ status         VARCHAR(20)                  │

                                    │ size           INTEGER                      │

### Status Badge System                                    │ gas_fees       BIGINT                       │

                                    │ total_output   BIGINT                       │

Each claim shows **3 independent badges:**                                    │ network        VARCHAR(20)                  │

                                    │ metadata       JSONB                        │

| Badge | Green | Red | Yellow |                                    │ explorer_url   TEXT                         │

|-------|-------|-----|--------|                                    │ fetched_at     TIMESTAMP                    │

| **ML Status** | ✅ ML Genuine | ❌ ML Fraud | ⏳ ML Pending |                                    │ updated_at     TIMESTAMP                    │

| **Image Status** | ✅ Verified | ❌ Failed | ⏳ Pending |                                    └─────────────────────────────────────────────┘

| **Payout Status** | ✅ Completed | ❌ Rejected | ⏳ Pending / 🚀 Triggering |```



**Rejection messages (card footer):****View**: `claim_transactions` — joins `claims` with `blockchain_transactions` for unified query.

- ML only: "Rejected — AI Fraud Detection"

- Image only: "Rejected — Document Verification Failed"---

- Both: "Rejected — AI & Document Verification"

## 7. API Reference

---

### Python ML Service (port 8000, proxied at `/api/`)

## 11. Automation Service

| Method | Endpoint | Request | Response | Description |

The Go service is the **orchestrator** that connects ML decisions to blockchain payouts:|--------|----------|---------|----------|-------------|

| GET | `/` | — | `{ status, model, accuracy, f1_score, timestamp }` | Health check with model info |

```| POST | `/predict` | `{ user_id, amount_billed, diagnosis }` | `{ claim_id, prediction_label, confidence, ml_status, message }` | Submit claim for ML fraud detection |

Every 60 seconds:| GET | `/users/{wallet_address}` | — | `{ user_id, name, email, wallet_address, age, gender, expiry_date, premium, claims[] }` | Get user by wallet (auto-registers new wallets) |

  1. Query: SELECT claims WHERE payout_status = 'trigger' AND ml_status = 'genuine'| PUT | `/users/{wallet_address}/profile` | `{ name?, age?, gender? }` | `{ message, user_id, name, age, gender }` | Update user profile (name, age, gender) |

  2. For each triggered claim:| PUT | `/claims/{id}/trigger-payout` | `{ payout_address? }` | `{ message, claim_id, status, note }` | Trigger payout (sets status to 'trigger') |

     a. Hash user ID: Blake2b-256(name + email)| POST | `/verify-images` | FormData: `claim_id`, `prescription_image`, `receipt_image` | `{ claim_id, image_verification, combined_score, ml_score, final_status, message }` | GPT-4o prescription vs receipt verification |

     b. POST to Node.js: /api/payout-transaction| GET | `/model/info` | — | `{ model_name, accuracy, f1_score, n_features, training_date, top_features[] }` | Detailed model information |

     c. Node.js builds TX → signs with treasury → submits to Cardano| GET | `/recent-activity?limit=N` | — | `{ transactions[], count }` | Public feed of completed payouts |

     d. Update claim: payout_status = 'completed', tx_hash = <hash>

     e. Insert into public_payouts (hashed_user_id, amount, tx_hash)### Node.js Blockchain Service (port 3001, proxied at `/service/`)

  3. Update confirmations for recent transactions

     - Fetch latest block data from Blockfrost| Method | Endpoint | Request | Response | Description |

     - Sync block_height to claims table|--------|----------|---------|----------|-------------|

```| GET | `/health` | — | `{ status, network, smartContract{}, treasuryWallet{}, totalBalanceADA }` | Service health + wallet/script balances |

| GET | `/api/balance` | — | `{ wallet{}, smartContract{}, totalBalanceADA }` | Detailed balance breakdown |

---| GET | `/api/epoch` | — | `{ epoch, slot, block_height, block_time, network }` | Current Cardano epoch/slot info |

| POST | `/api/payout-transaction` | `{ recipientAddress, amountLovelace, hashedUserId, claimMetadata{} }` | `{ success, txHash, explorerUrl, network, timestamp }` | Build, sign & submit ADA payout |

## 12. API Endpoints| GET | `/api/transaction/:txHash` | — | `{ txHash, blockHeight, slot, confirmations, fees, metadata{}, inputs[], outputs[], explorerUrl }` | Full transaction details from Blockfrost |



### ML Service (Python FastAPI — Port 8000, proxied at `/api/`)---



| Method | Endpoint | Description |## 8. Smart Contract Details

|--------|----------|-------------|

| `GET` | `/` | Health check — model name, accuracy, F1 score |### Insurance Gatekeeper (Plutus V3)

| `POST` | `/predict` | Submit claim → ML fraud prediction |

| `GET` | `/users/{wallet_address}` | Get user + claims (auto-registers new wallets) |The Aiken smart contract serves as the **on-chain governance layer**. It is compiled and deployed to Cardano Preprod with 500 tADA locked at its script address.

| `PUT` | `/claims/{id}/trigger-payout` | Trigger blockchain payout for approved claim |

| `PUT` | `/users/{wallet}/profile` | Update user profile (name, age, gender) |#### Validator Logic (Pseudocode)

| `POST` | `/verify-images` | Upload prescription + receipt for GPT-4o verification |```

| `GET` | `/model/info` | Detailed model metadata + feature importance |WHEN spending from script:

| `GET` | `/recent-activity` | Last 10 claims for public landing page |  1. CHECK transaction.extra_signatories CONTAINS treasury_pkh

     → Ensures only the insurance treasury can authorize payouts

### Blockchain Service (Node.js — Port 3001, proxied at `/service/`)  2. CHECK datum.hashed_user_id IS NOT empty

     → Ensures every payout is linked to a specific (hashed) user

| Method | Endpoint | Description |  3. BOTH conditions must be TRUE → allow spend

|--------|----------|-------------|  4. ELSE → reject transaction

| `GET` | `/health` | Wallet + script balance, UTXOs, network |```

| `POST` | `/api/payout-transaction` | Build, sign, submit ADA transaction |

| `GET` | `/api/transaction/:txHash` | Full transaction details from Blockfrost |#### Data Types

| `GET` | `/api/balance` | Treasury wallet + smart contract balance |- **Datum** (`InsuranceDatum`): `{ hashed_user_id: ByteArray }` — Blake2b-256 hash of (name + email)

| `GET` | `/api/epoch` | Current epoch, slot, block height |- **Redeemer** (`InsuranceRedeemer`): `{ Void }` — empty, all validation is via signatures



---#### Current Usage

The smart contract is **referenced but not spent** in the current system. Each payout transaction includes the script address in its metadata field, creating an on-chain link. The compiled code constant is stored in `app.ts` and the script address is derived using `resolvePlutusScriptAddress()`. The script's UTxO balance is monitored and displayed in the `/health` and `/api/balance` endpoints.

## 13. Deployment Infrastructure

---

### DigitalOcean Droplet

- **IP:** 178.128.212.100## 9. ML Model Details

- **OS:** Ubuntu 22.04 LTS

- **RAM:** 2GB### Training Pipeline

- **Firewall (UFW):** Ports 22, 80, 443 only

1. **Dataset**: 20,000 simulated healthcare claims (`data/healthcare_claims.csv`)

### systemd Services   - Features: Age, Gender, Date Admitted, Date Discharged, Diagnosis, Amount Billed

| Service | Runs | Restart |   - Target: Fraud Type (binary: No Fraud vs Phantom Billing/etc.)

|---------|------|---------|

| `healthtrust-ml` | `uvicorn main:app --port 8000 --workers 2` | Always, 5s delay |2. **Feature Engineering**:

| `healthtrust-blockchain` | `node -r ts-node/register src/app.ts` | Always, 5s delay |   - `FraudStatus`: binary (0=genuine, 1=fraud)

| `healthtrust-automation` | Compiled Go binary | Always, 10s delay |   - `StayDuration`: days between admission and discharge

   - One-Hot Encoding: Gender, Diagnosis → 13 features total

### Nginx Routing   - Train/Test split: 75/25, stratified

```

/           → /opt/HealthTrust/client/dist/ (static Vue SPA)3. **Models Trained** (7 total):

/api/*      → http://127.0.0.1:8000/*       (Python ML)   | Model | Accuracy | F1 Score |

/service/*  → http://127.0.0.1:3001/*       (Node.js blockchain)   |-------|----------|----------|

```   | Logistic Regression | ~82% | ~0.80 |

   | SVC | ~83% | ~0.81 |

### Deployment Command   | KNN (k=30) | ~80% | ~0.78 |

```bash   | Decision Tree | ~79% | ~0.77 |

bash deploy.sh   | Random Forest | ~85% | ~0.84 |

# 1. Builds frontend (npm run build)   | **Gradient Boosting** | **~86.3%** | **~0.85** |

# 2. rsync to server (excludes node_modules, venv, .git)   | Voting Ensemble | ~85% | ~0.84 |

# 3. Restarts all 3 services + reloads Nginx

```4. **Selected Model**: Gradient Boosting Classifier (best F1 score)



---5. **Confidence Threshold**: 90% — if the model predicts "genuine" but with < 90% confidence, the claim is automatically rejected and flagged for manual review.



## 14. Claim Lifecycle### Image Verification



```The image verification is a secondary layer using OpenAI's GPT-4o Vision:

[1] USER CONNECTS WALLET- **4 API calls** per verification: 2 for OCR (prescription + receipt), 2 for extraction/comparison

    └→ CIP-30 → bech32 address → GET /users/{addr} → auto-register if new- Handles: handwritten prescriptions, OCR errors, brand/generic equivalences, abbreviations

- Scoring: percentage of receipt items matched to prescription

[2] USER SUBMITS CLAIM- Combined with ML: `(ML_confidence% + Image_score%) / 2`

    └→ POST /predict → ML scores claim- Threshold: ≥ 80% combined → approved

       ├→ genuine (≥90% confidence) → payout_status = 'pending'

       └→ fake (or <90% confidence) → payout_status = 'rejected'---



[3] USER UPLOADS IMAGES (optional)## 10. Security & Privacy

    └→ POST /verify-images → GPT-4o compares prescription vs receipt

       ├→ combined_score ≥ 80% → images = 'genuine'### Privacy Measures

       └→ combined_score < 80% → images = 'fake', payout_status = 'rejected'- **Blake2b-256 Hashing**: User identity (name + email) is hashed before going on-chain. The `public_payouts` table and on-chain metadata only contain the hash, never the actual user data.

- **On-chain metadata**: Only contains claim_id, amount, ml_status, hashed_user_id — no PII.

[4] USER TRIGGERS PAYOUT

    └→ PUT /claims/{id}/trigger-payout### Access Control

       Guards: ml_status=genuine, images≠fake, payout_status=pending- All backend services bind to `127.0.0.1` (not exposed to internet directly).

       └→ payout_status = 'trigger'- Nginx is the only public-facing service (port 80).

- Rate limiting: 10 req/s for API endpoints, 30 req/s for frontend.

[5] GO AUTOMATION (every 60s)- CORS enabled (should be restricted in production).

    └→ Picks up triggered claims → calls Node.js

       └→ MeshSDK builds TX → signs → submits to Cardano### Wallet Security

          └→ payout_status = 'completed', tx_hash stored- Treasury mnemonic stored only in `.env` file (gitignored).

- Smart contract requires treasury signature for any fund withdrawal.

[6] TRANSACTION CONFIRMED- CIP-30 wallet connection is client-side only (private keys never leave the browser).

    └→ Go syncs block_height, confirmations

    └→ User can view full details + CardanoScan link### Deployment Hardening (systemd units)

```- `NoNewPrivileges=true`

- `ProtectSystem=strict`

---- `ProtectHome=true`

- `PrivateTmp=true`

## 15. Security & Privacy

---

| Concern | Implementation |

|---------|---------------|## 11. Deployment Architecture

| **Wallet secrets** | Treasury mnemonic + API keys in `.env` (gitignored, never committed) |

| **User privacy** | Public payouts use Blake2b-256 hash of (name + email) — never expose real identity |### Local Development (Current)

| **Backend isolation** | ML (8000) and Blockchain (3001) bound to `127.0.0.1` — not publicly accessible |```

| **Nginx only** | Port 80 is the only public-facing service |ngrok (HTTPS tunnel)

| **Firewall** | UFW allows only ports 22, 80, 443 |  └── Nginx :80

| **systemd hardening** | `NoNewPrivileges`, `ProtectSystem=strict`, `ProtectHome`, `PrivateTmp` |       ├── /         → client/dist/ (Vue static build)

| **CORS** | Configured on both services (currently `*` for development) |       ├── /api/*    → 127.0.0.1:8000 (Python FastAPI)

| **Input validation** | Pydantic models with validators, CHECK constraints in PostgreSQL |       └── /service/* → 127.0.0.1:3001 (Node.js Express)

| **Smart contract** | Requires treasury signature for every payout (on-chain enforcement) |

| **Confidence threshold** | 90% threshold rejects borderline genuine predictions |Background:

  ├── Go automation (polling PostgreSQL every 60s)

---  └── PostgreSQL :5432 (database: HealthTrust)

```

*Last updated: 23 February 2026*

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
