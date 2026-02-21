#!/bin/bash
set -euo pipefail

# ============================================================================
# HealthTrust — Production Deployment Script
# Run as root on a fresh Ubuntu 22.04+ server
# Usage: sudo bash deploy.sh
# ============================================================================

DOMAIN="${DOMAIN:-yourdomain.com}"
EMAIL="${EMAIL:-admin@yourdomain.com}"
APP_USER="healthtrust"
APP_DIR="/opt/healthtrust"

echo "============================================================"
echo "🚀 HealthTrust Production Deployment"
echo "   Domain: $DOMAIN"
echo "   App Dir: $APP_DIR"
echo "============================================================"
echo ""

# --- Preflight check ---
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root: sudo bash deploy.sh"
    exit 1
fi

# --- 1. System packages ---
echo "📦 Installing system packages..."
apt update && apt upgrade -y
apt install -y nginx postgresql postgresql-contrib python3 python3-pip python3-venv \
    golang-go nodejs npm ufw certbot python3-certbot-nginx git build-essential curl

# --- 2. Create application user ---
echo "👤 Creating application user..."
id $APP_USER &>/dev/null || useradd --system --create-home --shell /bin/bash $APP_USER

# --- 3. Setup project directory ---
echo "📂 Setting up project directory..."
mkdir -p $APP_DIR
if [ -d "$APP_DIR/.git" ]; then
    cd $APP_DIR && git pull
else
    # Copy current project or clone from repo
    echo "   Copy your project files to $APP_DIR"
fi
chown -R $APP_USER:$APP_USER $APP_DIR

# --- 4. Build Vue frontend ---
echo "🎨 Building Vue frontend..."
cd $APP_DIR/client
npm ci --production=false
VITE_API_URL=https://$DOMAIN/api npm run build
mkdir -p /var/www/healthtrust
cp -r dist/* /var/www/healthtrust/
chown -R www-data:www-data /var/www/healthtrust

# --- 5. Setup Python ML service ---
echo "🐍 Setting up Python ML service..."
cd $APP_DIR/ml-service
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate

# --- 6. Build Go automation service ---
echo "🔧 Building Go automation service..."
cd $APP_DIR/automation-service
go build -o automation-service .
chown $APP_USER:$APP_USER automation-service

# --- 7. Setup Node.js blockchain service ---
echo "⛓️  Setting up blockchain service..."
cd $APP_DIR/server/blockchain-service
npm ci

# --- 8. Install systemd services ---
echo "⚙️  Installing systemd services..."
cp $APP_DIR/deploy/healthtrust-ml.service /etc/systemd/system/
cp $APP_DIR/deploy/healthtrust-go.service /etc/systemd/system/
cp $APP_DIR/deploy/healthtrust-blockchain.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable healthtrust-ml healthtrust-go healthtrust-blockchain

# --- 9. Install Nginx config ---
echo "🌐 Configuring Nginx..."
# Replace domain placeholder in Nginx config
sed "s/yourdomain.com/$DOMAIN/g" $APP_DIR/deploy/healthtrust.nginx > /etc/nginx/sites-available/healthtrust
ln -sf /etc/nginx/sites-available/healthtrust /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

# --- 10. Firewall ---
echo "🔥 Configuring UFW firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw --force enable

# --- 11. TLS Certificate ---
echo "🔒 Obtaining TLS certificate..."
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m $EMAIL || {
    echo "⚠️  Certbot failed. Ensure DNS is pointing to this server."
    echo "   Run manually: certbot --nginx -d $DOMAIN"
}

# --- 12. Start services ---
echo "🚀 Starting services..."
systemctl start healthtrust-ml healthtrust-go healthtrust-blockchain

# --- 13. Verify ---
echo ""
echo "============================================================"
echo "✅ HealthTrust Deployment Complete!"
echo "============================================================"
echo ""
echo "Services:"
systemctl is-active healthtrust-ml healthtrust-go healthtrust-blockchain nginx postgresql || true
echo ""
echo "URLs:"
echo "  Frontend:   https://$DOMAIN"
echo "  ML API:     https://$DOMAIN/api/"
echo "  Blockchain: https://$DOMAIN/service/health"
echo ""
echo "⚠️  MANUAL STEPS REMAINING:"
echo "  1. Create /opt/healthtrust/.env with production secrets"
echo "  2. Run database setup: sudo -u postgres psql -d HealthTrust -f database/schema.sql"
echo "  3. Create DB app user (see DEPLOYMENT_GUIDE.md section 5.2)"
echo "  4. Lock down pg_hba.conf (see DEPLOYMENT_GUIDE.md section 5.4)"
echo "  5. Restart services: sudo systemctl restart healthtrust-ml healthtrust-go healthtrust-blockchain"
echo "============================================================"
