#!/bin/bash
# ============================================
# HealthTrust - DigitalOcean Server Setup
# Run this script as root on a fresh Ubuntu 22.04 droplet
# Usage: bash setup-server.sh
# ============================================

set -e

echo "============================================"
echo "🏥 HealthTrust Server Setup"
echo "============================================"

# ---- System Updates ----
echo ""
echo "📦 Step 1: Updating system packages..."
apt update && apt upgrade -y

# ---- Install Node.js 22 ----
echo ""
echo "📦 Step 2: Installing Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs
echo "   Node.js version: $(node --version)"
echo "   npm version: $(npm --version)"

# ---- Install Python 3.10+ ----
echo ""
echo "📦 Step 3: Installing Python 3..."
apt install -y python3 python3-pip python3-venv
echo "   Python version: $(python3 --version)"

# ---- Install Go ----
echo ""
echo "📦 Step 4: Installing Go 1.22..."
cd /tmp
wget -q https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
export PATH=$PATH:/usr/local/go/bin
echo "   Go version: $(go version)"

# ---- Install PostgreSQL ----
echo ""
echo "📦 Step 5: Installing PostgreSQL..."
apt install -y postgresql postgresql-contrib
systemctl start postgresql
systemctl enable postgresql
echo "   PostgreSQL installed and running"

# ---- Install Nginx ----
echo ""
echo "📦 Step 6: Installing Nginx..."
apt install -y nginx
systemctl start nginx
systemctl enable nginx
echo "   Nginx installed and running"

# ---- Install Certbot (for SSL later) ----
echo ""
echo "📦 Step 7: Installing Certbot for SSL..."
apt install -y certbot python3-certbot-nginx

# ---- Install Git ----
echo ""
echo "📦 Step 8: Installing Git..."
apt install -y git
echo "   Git version: $(git --version)"

# ---- Create app user ----
echo ""
echo "📦 Step 9: Creating healthtrust user..."
if ! id "healthtrust" &>/dev/null; then
    useradd -m -s /bin/bash healthtrust
    echo "   Created user: healthtrust"
else
    echo "   User healthtrust already exists"
fi

# ---- Clone repository ----
echo ""
echo "📦 Step 10: Cloning repository..."
cd /home/healthtrust
if [ ! -d "model_1" ]; then
    sudo -u healthtrust git clone https://github.com/Yadurshan-R/HealthTrust.git model_1
    echo "   Repository cloned"
else
    cd model_1
    sudo -u healthtrust git pull origin master
    echo "   Repository updated"
fi

echo ""
echo "============================================"
echo "✅ Base system setup complete!"
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Setup database:  bash /home/healthtrust/model_1/deploy/setup-database.sh"
echo "  2. Setup services:  bash /home/healthtrust/model_1/deploy/setup-services.sh"
echo "  3. Setup nginx:     bash /home/healthtrust/model_1/deploy/setup-nginx.sh"
echo ""
