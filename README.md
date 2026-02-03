# 🏥 Healthcare Insurance Fraud Detection dApp

**AI-Powered Insurance Claims Processing on Cardano Blockchain**

[![Cardano](https://img.shields.io/badge/Cardano-Preprod-blue)](https://preprod.cardanoscan.io)
[![ML Model](https://img.shields.io/badge/ML%20Accuracy-86.3%25-green)](ml-service/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## 🎯 Project Overview

A decentralized insurance application that uses **AI fraud detection** combined with **Cardano blockchain** to automate claim verification and payouts. The system ensures transparency, immutability, and privacy while maintaining high accuracy in fraud detection.

### Key Features

- ✅ **AI Fraud Detection** - 86.3% accuracy using Gradient Boosting
- ✅ **Blockchain Payouts** - Automated on-chain transactions via MeshSDK
- ✅ **Privacy Preserved** - Blake2b hashing for user data
- ✅ **Transparent Records** - All payouts recorded on Cardano Preprod
- ✅ **Real-time Processing** - 60-second automation polling

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                Vue 3 Frontend (client/)                 │
│          User submits claims, views results             │
└──────────┬──────────────────────────────────────────────┘
           │
           ├─────────────┬──────────────┬─────────────────┐
           ▼             ▼              ▼                 ▼
    ┌──────────┐  ┌───────────┐  ┌───────────┐   ┌────────────┐
    │ML Service│  │Go Service │  │Blockchain │   │ PostgreSQL │
    │(Python)  │  │(Automation)│  │(Node.js)  │   │ Database   │
    │Port 8000 │  │Background │  │Port 3001  │   │ Port 5432  │
    └──────────┘  └───────────┘  └─────┬─────┘   └────────────┘
                                        │
                                        ▼
                              ┌──────────────────┐
                              │ Cardano Preprod  │
                              │  Testnet         │
                              └──────────────────┘
```

---

## 📁 Project Structure

```
model_1/
├── client/                      # Vue 3 Frontend
│   ├── src/
│   │   ├── components/         # Vue components
│   │   ├── views/              # Page views
│   │   └── App.vue             # Root component
│   └── package.json
│
├── server/
│   ├── blockchain-service/     # Node.js + MeshSDK
│   │   ├── src/app.ts         # Cardano integration
│   │   └── package.json
│   └── go-api/                 # Go API (future)
│
├── ml-service/                 # Python ML Service
│   ├── app.py                 # Flask API
│   └── voting_classifier_model.pkl
│
├── database/
│   └── migrations/             # SQL schemas
│
├── docs/                       # Documentation
│   ├── QUICKSTART_COMPLETE.md
│   ├── RUN_COMPLETE_SYSTEM.md
│   └── FOLDER_STRUCTURE.md
│
├── passwords.md                # Credentials (gitignored)
└── start-all-services.sh      # One-command startup
```

See detailed structure: [`docs/FOLDER_STRUCTURE.md`](docs/FOLDER_STRUCTURE.md)

---

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- Python 3.8+
- Go 1.20+
- PostgreSQL 14+

### 1. Clone & Setup

```bash
cd /home/yadu/Development/My_FYP/model_1

# Apply database migrations
sudo -u postgres psql HealthTrust < database/migrations/004_add_payout_date.sql
```

### 2. Install Dependencies

```bash
# Frontend
cd client && npm install

# Blockchain Service
cd server/blockchain-service && npm install

# ML Service
cd ml-service && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt
```

### 3. Configure Environment

Edit `.env` file:
```bash
DATABASE_URL=postgresql://yadu:Ashokan321@localhost:5432/HealthTrust
BLOCKFROST_API_KEY=your_blockfrost_key_here
TREASURY_MNEMONIC="your 24 word mnemonic"
```

See all credentials in `passwords.md`

### 4. Start All Services

```bash
./start-all-services.sh
```

Or manually in separate terminals:
```bash
# Terminal 1: ML Service
cd ml-service && source venv/bin/activate && python app.py

# Terminal 2: Blockchain Service
cd server/blockchain-service && npm run dev

# Terminal 3: Go Automation
cd automation-service && go run *.go

# Terminal 4: Frontend
cd client && npm run dev
```

### 5. Access the App

Open: **http://localhost:5173**

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Quick Start](docs/QUICKSTART_COMPLETE.md) | Fast setup guide |
| [Complete Guide](docs/RUN_COMPLETE_SYSTEM.md) | Detailed instructions |
| [Folder Structure](docs/FOLDER_STRUCTURE.md) | Project organization |
| [Implementation Summary](docs/IMPLEMENTATION_SUMMARY.md) | What was built |
| `passwords.md` | All credentials (local only) |

---

## 🧪 Testing the Flow

### 1. Submit a Claim

- Open http://localhost:5173
- Fill in patient details
- Amount: 100 tADA
- Submit

### 2. ML Prediction

- System automatically predicts: `genuine` or `fake`
- Confidence score displayed

### 3. Trigger Payout

- If genuine → Click "Claim Amount"
- Wait 60 seconds for automation

### 4. Verify on Blockchain

- Transaction hash appears
- Click to view on CardanoScan
- Check metadata label 674

---

## 🔧 Technology Stack

### Frontend
- Vue 3 (Composition API)
- TypeScript
- Vite
- MeshSDK (Cardano wallet)

### Backend
- **ML Service:** Python + Flask + Scikit-learn
- **Blockchain:** Node.js + MeshSDK + Blockfrost
- **Automation:** Go (polling & processing)

### Blockchain
- Cardano Preprod Testnet
- MeshSDK for transactions
- Blockfrost API for data
- Metadata label 674 for claim data

### Database
- PostgreSQL 14+
- Tables: users, claims, blockchain_transactions

---

## 📊 ML Model Performance

- **Algorithm:** Gradient Boosting Classifier
- **Accuracy:** 86.3%
- **Features:** Age, diagnosis, amount, medical history
- **Output:** Binary classification (genuine/fake)

---

## 🔒 Security & Privacy

- **User Privacy:** Blake2b hashing for public records
- **Treasury Security:** Mnemonic stored in `.env` (gitignored)
- **Database:** Encrypted connections
- **Testnet Only:** All testing on Cardano Preprod

---

## 🎓 Academic Context

**Final Year Project (FYP)**  
**Topic:** AI-Powered Healthcare Insurance Fraud Detection on Blockchain

**Key Contributions:**
1. Integration of ML with blockchain for insurance
2. Automated payout system with fraud prevention
3. Privacy-preserving public ledger
4. Real-world Cardano testnet deployment

---

## 🚧 Future Enhancements

- [ ] Deploy to Cardano mainnet
- [ ] Implement Aiken smart contracts
- [ ] Add batch claim processing
- [ ] Real-time confirmation tracking in UI
- [ ] Multi-wallet support (Lace, Eternl, Nami)

---

## 🤝 Contributing

This is an academic project. For questions or collaboration:

1. Review documentation in `docs/`
2. Check `passwords.md` for credentials
3. Follow folder structure in `FOLDER_STRUCTURE.md`

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file

---

## 🔗 Resources

- [Cardano Docs](https://docs.cardano.org)
- [MeshSDK](https://meshjs.dev)
- [Blockfrost](https://blockfrost.io)
- [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/)

---

## 💡 Quick Commands

```bash
# Start everything
./start-all-services.sh

# Check services
curl http://localhost:8000/health     # ML
curl http://localhost:3001/health     # Blockchain
curl http://localhost:5173            # Frontend

# Check treasury balance
curl http://localhost:3001/api/balance

# View database
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust

# Stop all services
lsof -ti:8000,3001,5173 | xargs kill -9
```

---

**🎉 Your Healthcare Insurance dApp is ready!**

For detailed setup, see: [`docs/RUN_COMPLETE_SYSTEM.md`](docs/RUN_COMPLETE_SYSTEM.md)
