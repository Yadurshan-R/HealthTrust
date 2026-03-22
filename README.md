# HealthTrust

**Final Year Project** — HealthTrust: An AI-Driven Blockchain bApp for Automated Healthcare Insurance Fraud Detection and Instant Claims Settlement

[![Cardano](https://img.shields.io/badge/Cardano-Preprod_Testnet-blue)](https://preprod.cardanoscan.io)
[![ML Accuracy](https://img.shields.io/badge/ML_Accuracy-86.3%25-green)](ml-service/)
[![Vue 3](https://img.shields.io/badge/Frontend-Vue_3-42b883)](client/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

> 🌐 **Live Demo:** [http://178.128.212.100](http://178.128.212.100) (Cardano Preprod Testnet)

---

## 🎯 What Is HealthTrust?

HealthTrust is a **blockchain application (bApp)** that combines:
- **AI fraud detection** (Gradient Boosting, 86.3% accuracy)
- **GPT-4o Vision document verification**
- **Automated Cardano Preprod payouts**

It uses Cardano as a **transparent settlement and audit layer**. All payouts are recorded on-chain with **CIP-20 metadata**, while ML and automation run on centralized services.

---

## ✨ Key Features

- 🤖 **AI Fraud Detection** — Gradient Boosting classifier with SMOTE, 86.3% accuracy  
- 🖼️ **Image Verification** — GPT-4o Vision compares prescription vs receipt  
- ⛓️ **Blockchain Payouts** — Automated ADA payouts on Cardano Preprod via MeshSDK  
- 📋 **On-Chain Records** — CIP-20 metadata for every payout (label 674)  
- 🔒 **Privacy Preserved** — Blake2b-256 hashed user IDs, no PII on-chain  
- ⚡ **60-Second Automation** — Go service polls DB and triggers payouts  

---

## 🏗️ High-Level Architecture

- **Frontend:** Vue 3 + TailwindCSS + MeshSDK (served by Nginx)
- **ML Service:** Python (FastAPI) — fraud prediction + image verification
- **Blockchain Service:** Node.js (Express + MeshSDK + Blockfrost)
- **Automation:** Go — polls PostgreSQL and triggers payouts
- **Smart Contract:** Aiken Plutus V3 validator (Insurance Gatekeeper)
- **Database:** PostgreSQL — users, claims, blockchain transactions

---

## 🚀 How to Run (Local)

1. **Clone repo**
   ```bash
   git clone https://github.com/Yadurshan-R/HealthTrust.git
   cd HealthTrust
   ```

2. **Set up PostgreSQL** (create DB `HealthTrust`, run `database/schema.sql`, `seed.sql` and migrations).

3. **Configure `.env` files** for:
   - `ml-service`
   - `server/blockchain-service`
   - `automation-service` (or root)

4. **Start services (dev)**
   - ML service (FastAPI)
   - Blockchain service (Node.js)
   - Automation (Go)
   - Frontend (Vue dev server or Nginx in prod)

See detailed setup docs in the project for full commands.

---

## 📄 License

MIT — see [LICENSE](LICENSE).

*Built by [Yadurshan R](https://github.com/Yadurshan-R) — Final Year Project 2025/2026*