#!/bin/bash

# 🚀 Complete System Startup Script
# Starts all services for Healthcare Insurance dApp

set -e

echo "============================================================"
echo "🚀 Starting Healthcare Insurance dApp - Complete System"
echo "============================================================"
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project root
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}📍 Project root: $PROJECT_ROOT${NC}"
echo ""

# Apply database patches
echo -e "${YELLOW}📊 Applying database patches...${NC}"
if [ -f "database/migrations/004_add_payout_date.sql" ]; then
    sudo -u postgres psql HealthTrust < database/migrations/004_add_payout_date.sql
    echo -e "${GREEN}✅ Database patches applied${NC}"
else
    echo -e "${YELLOW}⚠️  Patch file not found, skipping...${NC}"
fi
echo ""

# Check if services are already running
echo -e "${YELLOW}🔍 Checking for running services...${NC}"

# Kill existing processes on ports if needed
lsof -ti:8000 | xargs kill -9 2>/dev/null || true
lsof -ti:3001 | xargs kill -9 2>/dev/null || true
lsof -ti:5173 | xargs kill -9 2>/dev/null || true

echo -e "${GREEN}✅ Ports cleared${NC}"
echo ""

# Start services in background
echo "============================================================"
echo "🎬 Starting Services..."
echo "============================================================"
echo ""

# 1. ML Service
echo -e "${BLUE}1️⃣  Starting ML Service (Port 8000)...${NC}"
cd "$PROJECT_ROOT/ml-service"
if [ -d "venv" ]; then
    source venv/bin/activate
    nohup python app.py > /tmp/ml-service.log 2>&1 &
    ML_PID=$!
    echo -e "${GREEN}   ✅ ML Service started (PID: $ML_PID)${NC}"
    echo -e "   📋 Logs: tail -f /tmp/ml-service.log"
else
    echo -e "${YELLOW}   ⚠️  venv not found. Run: python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt${NC}"
fi
echo ""

# 2. Blockchain Service  
echo -e "${BLUE}2️⃣  Starting Blockchain Service (Port 3001)...${NC}"
cd "$PROJECT_ROOT/server/blockchain-service"
if [ -d "node_modules" ]; then
    nohup npm run dev > /tmp/blockchain-service.log 2>&1 &
    BLOCKCHAIN_PID=$!
    echo -e "${GREEN}   ✅ Blockchain Service started (PID: $BLOCKCHAIN_PID)${NC}"
    echo -e "   📋 Logs: tail -f /tmp/blockchain-service.log"
    sleep 3  # Wait for blockchain service to initialize
else
    echo -e "${YELLOW}   ⚠️  node_modules not found. Run: npm install${NC}"
fi
echo ""

# 3. Go Automation Service
echo -e "${BLUE}3️⃣  Starting Go Automation Service...${NC}"
cd "$PROJECT_ROOT/automation-service"
nohup go run *.go > /tmp/go-automation.log 2>&1 &
GO_PID=$!
echo -e "${GREEN}   ✅ Go Automation started (PID: $GO_PID)${NC}"
echo -e "   📋 Logs: tail -f /tmp/go-automation.log"
echo ""

# 4. Frontend
echo -e "${BLUE}4️⃣  Starting Frontend (Port 5173)...${NC}"
cd "$PROJECT_ROOT/client"
if [ -d "node_modules" ]; then
    nohup npm run dev > /tmp/frontend.log 2>&1 &
    FRONTEND_PID=$!
    echo -e "${GREEN}   ✅ Frontend started (PID: $FRONTEND_PID)${NC}"
    echo -e "   📋 Logs: tail -f /tmp/frontend.log"
else
    echo -e "${YELLOW}   ⚠️  node_modules not found. Run: npm install${NC}"
fi
echo ""

# Wait for services to start
echo -e "${YELLOW}⏳ Waiting for services to initialize (5 seconds)...${NC}"
sleep 5
echo ""

# Health checks
echo "============================================================"
echo "🏥 Health Checks"
echo "============================================================"
echo ""

# Check ML Service
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ ML Service: HEALTHY${NC}"
else
    echo -e "${YELLOW}⚠️  ML Service: NOT RESPONDING${NC}"
fi

# Check Blockchain Service
if curl -s http://localhost:3001/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Blockchain Service: HEALTHY${NC}"
    echo -e "   $(curl -s http://localhost:3001/health | jq -r '. | "Balance: \(.balanceADA) ADA, Network: \(.network)"' 2>/dev/null || echo 'Details available at http://localhost:3001/health')"
else
    echo -e "${YELLOW}⚠️  Blockchain Service: NOT RESPONDING${NC}"
fi

# Check Frontend
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend: HEALTHY${NC}"
else
    echo -e "${YELLOW}⚠️  Frontend: NOT RESPONDING${NC}"
fi

echo ""
echo "============================================================"
echo "🎉 System Status"
echo "============================================================"
echo ""
echo -e "${GREEN}All services started!${NC}"
echo ""
echo "📱 Access Points:"
echo "   • Frontend:    http://localhost:5173"
echo "   • ML API:      http://localhost:8000"
echo "   • Blockchain:  http://localhost:3001"
echo ""
echo "📊 Process IDs:"
echo "   • ML Service:        $ML_PID"
echo "   • Blockchain Service: $BLOCKCHAIN_PID"
echo "   • Go Automation:     $GO_PID"
echo "   • Frontend:          $FRONTEND_PID"
echo ""
echo "📋 View Logs:"
echo "   tail -f /tmp/ml-service.log"
echo "   tail -f /tmp/blockchain-service.log"
echo "   tail -f /tmp/go-automation.log"
echo "   tail -f /tmp/frontend.log"
echo ""
echo "🛑 Stop All Services:"
echo "   kill $ML_PID $BLOCKCHAIN_PID $GO_PID $FRONTEND_PID"
echo ""
echo "============================================================"
echo -e "${BLUE}🚀 Ready to test! Open http://localhost:5173${NC}"
echo "============================================================"
