#!/bin/bash
# ============================================
# HealthTrust - Services Setup
# Run as root after setup-database.sh
# ============================================

set -e

APP_DIR="/home/healthtrust/model_1"
DB_USER="healthtrust"
DB_PASS="HealthTrust_2026_Secure!"
DB_NAME="HealthTrust"

echo "============================================"
echo "⚙️  HealthTrust Services Setup"
echo "============================================"

# ---- ML Service (Python/FastAPI) ----
echo ""
echo "🐍 Step 1: Setting up ML Service..."
cd $APP_DIR/ml-service
sudo -u healthtrust python3 -m venv venv
sudo -u healthtrust bash -c "source venv/bin/activate && pip install -r requirements.txt"

# Create .env for ML service
cat > $APP_DIR/ml-service/.env << EOF
DATABASE_URL=postgresql://$DB_USER:$DB_PASS@localhost:5432/$DB_NAME
OPENAI_API_KEY=your_openai_api_key_here
HOST=127.0.0.1
PORT=8000
EOF
chown healthtrust:healthtrust $APP_DIR/ml-service/.env
echo "   ✅ ML Service ready"

# ---- Blockchain Service (Node.js) ----
echo ""
echo "⛓️  Step 2: Setting up Blockchain Service..."
cd $APP_DIR/server/blockchain-service
sudo -u healthtrust npm install
echo "   ✅ Blockchain Service ready"

# ---- Go Automation Service ----
echo ""
echo "🔄 Step 3: Setting up Go Automation Service..."
cd $APP_DIR/automation-service
export PATH=$PATH:/usr/local/go/bin
sudo -u healthtrust bash -c "export PATH=\$PATH:/usr/local/go/bin && cd $APP_DIR/automation-service && go build -o automation blockchain.go crypto.go database.go"
echo "   ✅ Go Automation Service ready"

# ---- Frontend (already built in dist/) ----
echo ""
echo "🌐 Step 4: Frontend already built in client/dist/"
echo "   ✅ Frontend ready"

# ---- Create systemd service files ----
echo ""
echo "📋 Step 5: Creating systemd services..."

# ML Service
cat > /etc/systemd/system/healthtrust-ml.service << EOF
[Unit]
Description=HealthTrust ML Service (FastAPI)
After=network.target postgresql.service

[Service]
Type=simple
User=healthtrust
WorkingDirectory=$APP_DIR/ml-service
Environment=PATH=$APP_DIR/ml-service/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
ExecStart=$APP_DIR/ml-service/venv/bin/python main.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Blockchain Service
cat > /etc/systemd/system/healthtrust-blockchain.service << EOF
[Unit]
Description=HealthTrust Blockchain Service (Node.js)
After=network.target

[Service]
Type=simple
User=healthtrust
WorkingDirectory=$APP_DIR/server/blockchain-service
ExecStart=/usr/bin/npx ts-node src/app.ts
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Go Automation Service
cat > /etc/systemd/system/healthtrust-automation.service << EOF
[Unit]
Description=HealthTrust Go Automation Service
After=network.target postgresql.service healthtrust-blockchain.service

[Service]
Type=simple
User=healthtrust
WorkingDirectory=$APP_DIR/automation-service
ExecStart=$APP_DIR/automation-service/automation
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable services
systemctl daemon-reload
systemctl enable healthtrust-ml healthtrust-blockchain healthtrust-automation

echo "   ✅ Systemd services created and enabled"

echo ""
echo "============================================"
echo "✅ All services setup complete!"
echo "============================================"
echo ""
echo "Start all services:"
echo "  systemctl start healthtrust-ml"
echo "  systemctl start healthtrust-blockchain"
echo "  systemctl start healthtrust-automation"
echo ""
echo "Check status:"
echo "  systemctl status healthtrust-ml"
echo "  systemctl status healthtrust-blockchain"
echo "  systemctl status healthtrust-automation"
echo ""
