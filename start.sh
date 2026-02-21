#!/bin/bash
# ============================================================================
# HealthTrust — Start All Services (Local Development)
# Usage: bash start.sh              (start all + ngrok public link)
#        bash start.sh local        (start all, localhost only)
#        bash start.sh stop         (stop all including ngrok)
#        bash start.sh status       (check status of all services)
#        bash start.sh restart      (restart everything)
# ============================================================================

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Stop all services ---
stop_all() {
    echo -e "${YELLOW}🛑 Stopping all HealthTrust services...${NC}"

    # Stop ngrok
    pkill -f "ngrok" 2>/dev/null && echo -e "   ${GREEN}✓${NC} ngrok tunnel stopped" || echo -e "   ${YELLOW}⚠${NC} ngrok was not running"

    # Stop Nginx
    sudo systemctl stop nginx 2>/dev/null && echo -e "   ${GREEN}✓${NC} Nginx stopped" || echo -e "   ${YELLOW}⚠${NC} Nginx was not running"

    # Stop ML service (Python/Uvicorn)
    pkill -f "python.*main.py" 2>/dev/null && echo -e "   ${GREEN}✓${NC} ML service stopped" || echo -e "   ${YELLOW}⚠${NC} ML service was not running"

    # Stop Blockchain service (Node.js)
    pkill -f "ts-node.*app.ts" 2>/dev/null && echo -e "   ${GREEN}✓${NC} Blockchain service stopped" || echo -e "   ${YELLOW}⚠${NC} Blockchain service was not running"

    # Stop Go automation
    pkill -f "go.run.*blockchain|go-build.*blockchain" 2>/dev/null && echo -e "   ${GREEN}✓${NC} Go automation stopped" || echo -e "   ${YELLOW}⚠${NC} Go automation was not running"

    sleep 1
    echo -e "${GREEN}✅ All services stopped${NC}"
}

# --- Check status ---
check_status() {
    echo -e "${BLUE}📊 HealthTrust Service Status${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Nginx
    if systemctl is-active --quiet nginx; then
        echo -e "   ${GREEN}●${NC} Nginx (port 80)              ${GREEN}RUNNING${NC}"
    else
        echo -e "   ${RED}●${NC} Nginx (port 80)              ${RED}STOPPED${NC}"
    fi

    # ML Service
    if pgrep -f "python.*main.py" > /dev/null 2>&1; then
        echo -e "   ${GREEN}●${NC} ML Service (port 8000)       ${GREEN}RUNNING${NC}"
    else
        echo -e "   ${RED}●${NC} ML Service (port 8000)       ${RED}STOPPED${NC}"
    fi

    # Blockchain Service
    if pgrep -f "ts-node.*app.ts" > /dev/null 2>&1; then
        echo -e "   ${GREEN}●${NC} Blockchain Service (port 3001) ${GREEN}RUNNING${NC}"
    else
        echo -e "   ${RED}●${NC} Blockchain Service (port 3001) ${RED}STOPPED${NC}"
    fi

    # Go Automation
    if pgrep -f "go.run.*blockchain|go-build.*blockchain" > /dev/null 2>&1; then
        echo -e "   ${GREEN}●${NC} Go Automation (poller)       ${GREEN}RUNNING${NC}"
    else
        echo -e "   ${RED}●${NC} Go Automation (poller)       ${RED}STOPPED${NC}"
    fi

    # ngrok
    if pgrep -f "ngrok" > /dev/null 2>&1; then
        NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])" 2>/dev/null)
        echo -e "   ${GREEN}●${NC} ngrok tunnel                 ${GREEN}RUNNING${NC}"
        if [ -n "$NGROK_URL" ]; then
            echo -e "     ${GREEN}🔗 Public URL: ${NGROK_URL}${NC}"
        fi
    else
        echo -e "   ${RED}●${NC} ngrok tunnel                 ${RED}STOPPED${NC}"
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Quick endpoint tests
    echo ""
    echo -e "${BLUE}🔗 Endpoint Health Checks${NC}"
    FRONTEND=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ 2>/dev/null)
    ML=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/api/ 2>/dev/null)
    BLOCKCHAIN=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/service/health 2>/dev/null)

    [ "$FRONTEND" = "200" ] && echo -e "   ${GREEN}✓${NC} Frontend     → HTTP $FRONTEND" || echo -e "   ${RED}✗${NC} Frontend     → HTTP $FRONTEND"
    [ "$ML" = "200" ] && echo -e "   ${GREEN}✓${NC} ML API       → HTTP $ML" || echo -e "   ${RED}✗${NC} ML API       → HTTP $ML"
    [ "$BLOCKCHAIN" = "200" ] && echo -e "   ${GREEN}✓${NC} Blockchain   → HTTP $BLOCKCHAIN" || echo -e "   ${RED}✗${NC} Blockchain   → HTTP $BLOCKCHAIN"
}

# --- Start all services ---
start_all() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   🚀 HealthTrust — Starting Services   ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""

    # Kill any existing instances first
    echo -e "${YELLOW}🧹 Cleaning up old processes...${NC}"
    pkill -f "ngrok" 2>/dev/null
    pkill -f "python.*main.py" 2>/dev/null
    pkill -f "ts-node.*app.ts" 2>/dev/null
    pkill -f "go.run.*blockchain|go-build.*blockchain" 2>/dev/null
    sleep 1

    # 1. Nginx
    echo -e "${BLUE}[1/4]${NC} Starting Nginx..."
    sudo systemctl start nginx 2>/dev/null
    if systemctl is-active --quiet nginx; then
        echo -e "   ${GREEN}✓ Nginx running on port 80${NC}"
    else
        echo -e "   ${RED}✗ Nginx failed to start${NC}"
        echo "   Check: sudo journalctl -u nginx --no-pager -n 10"
    fi

    # 2. Python ML Service
    echo -e "${BLUE}[2/4]${NC} Starting ML Service (Python/FastAPI)..."
    cd "$PROJECT_DIR/ml-service"
    source venv/bin/activate
    nohup python main.py > /tmp/healthtrust-ml.log 2>&1 &
    ML_PID=$!
    deactivate 2>/dev/null
    sleep 3
    if kill -0 $ML_PID 2>/dev/null; then
        echo -e "   ${GREEN}✓ ML Service running on port 8000 (PID: $ML_PID)${NC}"
    else
        echo -e "   ${RED}✗ ML Service failed to start${NC}"
        echo "   Check: cat /tmp/healthtrust-ml.log"
    fi

    # 3. Node.js Blockchain Service
    echo -e "${BLUE}[3/4]${NC} Starting Blockchain Service (Node.js/MeshSDK)..."
    cd "$PROJECT_DIR/server/blockchain-service"
    nohup npx ts-node src/app.ts > /tmp/healthtrust-blockchain.log 2>&1 &
    BLOCKCHAIN_PID=$!
    sleep 5
    if kill -0 $BLOCKCHAIN_PID 2>/dev/null; then
        echo -e "   ${GREEN}✓ Blockchain Service running on port 3001 (PID: $BLOCKCHAIN_PID)${NC}"
    else
        echo -e "   ${RED}✗ Blockchain Service failed to start${NC}"
        echo "   Check: cat /tmp/healthtrust-blockchain.log"
    fi

    # 4. Go Automation Service
    echo -e "${BLUE}[4/4]${NC} Starting Go Automation Service..."
    cd "$PROJECT_DIR/automation-service"
    nohup go run blockchain.go crypto.go database.go > /tmp/healthtrust-go.log 2>&1 &
    GO_PID=$!
    sleep 3
    if kill -0 $GO_PID 2>/dev/null; then
        echo -e "   ${GREEN}✓ Go Automation running (PID: $GO_PID)${NC}"
    else
        echo -e "   ${RED}✗ Go Automation failed to start${NC}"
        echo "   Check: cat /tmp/healthtrust-go.log"
    fi

    # Summary
    echo ""
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✅ All backend services started!${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo ""
    echo "  🌐 Local:      http://localhost/"
    echo "  🤖 ML API:     http://localhost/api/"
    echo "  ⛓️  Blockchain: http://localhost/service/health"
    echo ""
    echo "  📋 Logs:"
    echo "     ML:         tail -f /tmp/healthtrust-ml.log"
    echo "     Blockchain: tail -f /tmp/healthtrust-blockchain.log"
    echo "     Go:         tail -f /tmp/healthtrust-go.log"
    echo "     Nginx:      sudo tail -f /var/log/nginx/healthtrust_error.log"
    echo ""

    # Wait a moment then run health checks
    sleep 2
    check_status
}

# --- Start ngrok tunnel ---
start_ngrok() {
    echo ""
    echo -e "${BLUE}[5/5]${NC} Starting ngrok tunnel..."

    # Check if ngrok is installed
    if ! command -v ngrok &> /dev/null; then
        echo -e "   ${RED}✗ ngrok is not installed${NC}"
        echo "   Install: sudo snap install ngrok"
        echo "   Then:    ngrok config add-authtoken YOUR_TOKEN"
        return 1
    fi

    # Start ngrok in background
    nohup ngrok http 80 --log=stdout > /tmp/healthtrust-ngrok.log 2>&1 &
    NGROK_PID=$!
    sleep 3

    if kill -0 $NGROK_PID 2>/dev/null; then
        # Get the public URL
        NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])" 2>/dev/null)
        if [ -n "$NGROK_URL" ]; then
            echo -e "   ${GREEN}✓ ngrok tunnel running (PID: $NGROK_PID)${NC}"
            echo ""
            echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║  🌍 PUBLIC LINK: ${NGROK_URL}  ${NC}"
            echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
            echo ""
            echo "  Share this link with anyone to see your project!"
            echo "  Dashboard: http://127.0.0.1:4040"
        else
            echo -e "   ${YELLOW}⚠ ngrok started but couldn't get URL${NC}"
            echo "   Check: cat /tmp/healthtrust-ngrok.log"
        fi
    else
        echo -e "   ${RED}✗ ngrok failed to start${NC}"
        echo "   Check: cat /tmp/healthtrust-ngrok.log"
        echo "   Make sure you ran: ngrok config add-authtoken YOUR_TOKEN"
    fi
}

# --- Main ---
case "${1:-start}" in
    start)
        start_all
        start_ngrok
        ;;
    local)
        start_all
        echo -e "${YELLOW}  ℹ️  Running locally only (no ngrok). Use 'bash start.sh' for public link.${NC}"
        ;;
    stop)
        stop_all
        ;;
    restart)
        stop_all
        sleep 2
        start_all
        start_ngrok
        ;;
    status)
        check_status
        ;;
    *)
        echo ""
        echo "Usage: bash start.sh [command]"
        echo ""
        echo "Commands:"
        echo "  start     Start all services + ngrok public link (default)"
        echo "  local     Start all services, localhost only (no ngrok)"
        echo "  stop      Stop all services including ngrok"
        echo "  restart   Restart everything"
        echo "  status    Check status of all services"
        echo ""
        exit 1
        ;;
esac
