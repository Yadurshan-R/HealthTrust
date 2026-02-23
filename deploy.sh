#!/bin/bash
# ============================================
# HealthTrust - Quick Deploy to DigitalOcean
# Usage: bash deploy.sh
# ============================================

set -e

SERVER="root@178.128.212.100"
REMOTE_DIR="/opt/HealthTrust"
LOCAL_DIR="/home/yadu/Development/My_FYP/model_1"

echo "🚀 HealthTrust Deploy"
echo "====================="

# Step 1: Build frontend
echo ""
echo "📦 Building frontend..."
cd "$LOCAL_DIR/client"
npm run build

# Step 2: Sync files to server
echo ""
echo "📤 Syncing to server..."
cd "$LOCAL_DIR"
rsync -avz --delete \
  --exclude 'node_modules' \
  --exclude 'venv' \
  --exclude 'env' \
  --exclude '.venv' \
  --exclude '__pycache__' \
  --exclude '.git' \
  --exclude 'aiken-contracts/build' \
  . "$SERVER:$REMOTE_DIR/" 2>&1 | tail -3

# Step 3: Restart services
echo ""
echo "🔄 Restarting services..."
ssh "$SERVER" 'systemctl restart healthtrust-ml healthtrust-blockchain healthtrust-automation && systemctl reload nginx'

# Step 4: Verify
echo ""
echo "✅ Checking services..."
ssh "$SERVER" 'sleep 2 && systemctl is-active healthtrust-ml healthtrust-blockchain healthtrust-automation nginx'

echo ""
echo "🎉 Deploy complete!"
echo "   URL: http://178.128.212.100"
echo ""
