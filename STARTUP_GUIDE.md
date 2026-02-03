# HealthTrust Project - Complete Startup Guide

## Services to Start (in order):

### 1. PostgreSQL Database
Already running - no action needed

### 2. ML Service (Python - Port 8000)
```bash
cd /home/yadu/Development/My_FYP/model_1/ml-service
source venv/bin/activate
python main.py
```

### 3. Blockchain Service (Node.js - Port 3001)
```bash
cd /home/yadu/Development/My_FYP/model_1/server/blockchain-service
npm run dev
```

### 4. Automation Service (Go - Background)
```bash
cd /home/yadu/Development/My_FYP/model_1/automation-service
go run *.go
```

### 5. Frontend (Vue 3 - Port 5173)
```bash
cd /home/yadu/Development/My_FYP/model_1/client
npm run dev
```

## Expected Output

### ML Service should show:
- ✓ Database tables initialized
- ✓ Model loaded: Gradient Boosting
- ✓ ML Service started with Gradient Boosting
- Uvicorn running on http://0.0.0.0:8000

### Blockchain Service should show:
- ✅ Treasury wallet initialized
- 🚀 Blockchain Service Started Successfully!
- Server: http://localhost:3001

### Automation Service should show:
- ✓ Database connected
- 🚀 Cardano Insurance Automation Service Started
- 📡 Polling every 60 seconds

### Frontend should show:
- VITE ready in ~200ms
- Local: http://localhost:5173/

## Access Points
- Frontend: http://localhost:5173
- ML API: http://localhost:8000
- Blockchain API: http://localhost:3001
