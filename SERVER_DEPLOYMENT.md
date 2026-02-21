# 🚀 HealthTrust — Server Deployment (Step-by-Step)

> Copy this entire project to a Linux server via SSH and follow these steps **in order**.
> Tested with: Ubuntu 22.04 LTS | Node.js 22 | Python 3.10 | Go 1.21+ | PostgreSQL 16+

---

## ⚡ QUICK START — Run Locally & Share via ngrok

If you just want to run everything on your local machine and share a public link:

```bash
# Start all 5 services (Nginx + ML + Blockchain + Go + ngrok)
bash start.sh

# Or run locally only (no public link)
bash start.sh local

# Check status of all services
bash start.sh status

# Stop everything
bash start.sh stop
```

| Command | What it does |
|---------|-------------|
| `bash start.sh` | Start all services + ngrok public link |
| `bash start.sh local` | Start all services, localhost only |
| `bash start.sh stop` | Stop everything including ngrok |
| `bash start.sh restart` | Restart all services + ngrok |
| `bash start.sh status` | Show status of all 5 services |

> **First-time ngrok setup:** `sudo snap install ngrok && ngrok config add-authtoken YOUR_TOKEN`
> Get a free token at https://dashboard.ngrok.com/signup

---

## 📋 FULL SERVER DEPLOYMENT — What You Need

| Item | Example |
|------|---------|
| A Linux server (Ubuntu 22.04+) with root SSH access | `ssh root@your-server-ip` |
| A domain name pointing to the server IP (A record) | `healthtrust.yourdomain.com` |
| Your server IP address | e.g. `167.99.xxx.xxx` |
| At least 2GB RAM, 20GB disk | |

---

## STEP 1 — SSH into your server

```bash
ssh root@YOUR_SERVER_IP
```

If you have a key file:
```bash
ssh -i ~/.ssh/your-key root@YOUR_SERVER_IP
```

---

## STEP 2 — Create a non-root user (if you don't have one)

```bash
adduser healthtrust
usermod -aG sudo healthtrust
su - healthtrust
```

---

## STEP 3 — Install all system packages

```bash
sudo apt update && sudo apt upgrade -y

# Core packages
sudo apt install -y nginx postgresql postgresql-contrib \
    python3 python3-pip python3-venv \
    build-essential curl git ufw

# Node.js 22 (via NodeSource)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# Go 1.21+ (via official tarball)
wget https://go.dev/dl/go1.21.13.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.13.linux-amd64.tar.gz
rm go1.21.13.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify everything installed
node -v        # Should be v22.x
npm -v         # Should be 10.x
go version     # Should be go1.21+
python3 --version  # Should be 3.10+
nginx -v       # Should show nginx
psql --version # Should show PostgreSQL
```

---

## STEP 4 — Copy your project to the server

**FROM YOUR LOCAL MACHINE** (not the server), run:

```bash
# Option A: rsync (recommended — fast, resumable)
rsync -avz --exclude 'node_modules' \
            --exclude 'venv' \
            --exclude '__pycache__' \
            --exclude '.git' \
            --exclude 'client/dist' \
            /home/yadu/Development/My_FYP/model_1/ \
            healthtrust@YOUR_SERVER_IP:/home/healthtrust/healthtrust/

# Option B: scp (if rsync not available)
scp -r /home/yadu/Development/My_FYP/model_1/ healthtrust@YOUR_SERVER_IP:/home/healthtrust/healthtrust/
```

> 💡 After copying, **SSH back into the server**:
> ```bash
> ssh healthtrust@YOUR_SERVER_IP
> cd ~/healthtrust
> ls   # Should show: client/ ml-service/ automation-service/ server/ deploy/ etc.
> ```

---

## STEP 5 — Setup PostgreSQL Database

```bash
# 5.1 — Start PostgreSQL
sudo systemctl enable postgresql
sudo systemctl start postgresql

# 5.2 — Create the database and user
sudo -u postgres psql
```

Inside the PostgreSQL prompt:
```sql
CREATE DATABASE "HealthTrust";
CREATE USER healthtrust_app WITH ENCRYPTED PASSWORD 'YOUR_STRONG_PASSWORD_HERE';
GRANT ALL PRIVILEGES ON DATABASE "HealthTrust" TO healthtrust_app;
\c HealthTrust
GRANT ALL ON SCHEMA public TO healthtrust_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO healthtrust_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO healthtrust_app;
\q
```

```bash
# 5.3 — Load the schema
sudo -u postgres psql -d HealthTrust -f ~/healthtrust/database/schema.sql

# 5.4 — Apply migrations
sudo -u postgres psql -d HealthTrust -f ~/healthtrust/database/migrations/003_blockchain_transactions.sql
sudo -u postgres psql -d HealthTrust -f ~/healthtrust/database/migrations/004_add_payout_date.sql
sudo -u postgres psql -d HealthTrust -f ~/healthtrust/database/migrations/005_add_image_verification.sql

# 5.5 — Seed initial data (users, sample claims, etc.)
sudo -u postgres psql -d HealthTrust -f ~/healthtrust/database/seed.sql

# 5.6 — Verify tables exist
sudo -u postgres psql -d HealthTrust -c "\dt"
# Should show: users, claims, public_payouts, blockchain_transactions
```

```bash
# 5.7 — Lock down pg_hba.conf (only allow local connections)
sudo nano /etc/postgresql/*/main/pg_hba.conf
```
Find the line:
```
host    all    all    127.0.0.1/32    scram-sha-256
```
Make sure there is **NO** line allowing `0.0.0.0/0`. Save and restart:
```bash
sudo systemctl restart postgresql
```

---

## STEP 6 — Create the `.env` files

### 6.1 — Root `.env` (used by Go automation)

```bash
nano ~/healthtrust/.env
```

Paste:
```env
DATABASE_URL=postgresql://healthtrust_app:YOUR_STRONG_PASSWORD_HERE@localhost:5432/HealthTrust
BLOCKFROST_API_KEY=preprodHeO1e9abeJx2hfKcP8gS9y6y1PhhibL0
TREASURY_ADDRESS=addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78
TREASURY_MNEMONIC=your 24 word treasury mnemonic here
```

### 6.2 — ML service `.env`

```bash
nano ~/healthtrust/ml-service/.env
```

Paste:
```env
DATABASE_URL=postgresql://healthtrust_app:YOUR_STRONG_PASSWORD_HERE@localhost:5432/HealthTrust
OPENAI_API_KEY=sk-your-openai-key-here
```

### 6.3 — Blockchain service `.env`

```bash
nano ~/healthtrust/server/blockchain-service/.env
```

Paste:
```env
CARDANO_NETWORK=preprod
BLOCKFROST_API_KEY=preprodHeO1e9abeJx2hfKcP8gS9y6y1PhhibL0
TREASURY_MNEMONIC=your 24 word treasury mnemonic here
TREASURY_ADDRESS=addr_test1qzdegcxyjs8ujtgphecdqdkwg0ux4h8lwhkqgdghrpk9q4chv7gs0kwyfhynqh9kzv0h6fpydm2cxv3za8fslde3092qyv4n78
PORT=3001
```

> ⚠️ **IMPORTANT**: Copy your actual mnemonic and keys from your local `.env` files. Never commit `.env` files to git.

```bash
# Lock permissions on all .env files
chmod 600 ~/healthtrust/.env
chmod 600 ~/healthtrust/ml-service/.env
chmod 600 ~/healthtrust/server/blockchain-service/.env
```

---

## STEP 7 — Build the Vue.js Frontend

```bash
cd ~/healthtrust/client
npm ci

# Build with your domain as the API URL
VITE_API_URL=https://YOUR_DOMAIN/api npm run build
# e.g. VITE_API_URL=https://healthtrust.example.com/api npm run build

# Copy built files to Nginx web root
sudo mkdir -p /var/www/healthtrust
sudo cp -r dist/* /var/www/healthtrust/
sudo chown -R www-data:www-data /var/www/healthtrust
```

---

## STEP 8 — Setup Python ML Service

```bash
cd ~/healthtrust/ml-service
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
deactivate

# Quick test (should print "healthy")
cd ~/healthtrust/ml-service
source venv/bin/activate
python -c "from main import app; print('OK')"
deactivate
```

---

## STEP 9 — Setup Node.js Blockchain Service

```bash
cd ~/healthtrust/server/blockchain-service
npm ci

# Quick test (should start without errors, then Ctrl+C)
npx ts-node src/app.ts
# Wait for "Blockchain Service Started Successfully!" then Ctrl+C
```

---

## STEP 10 — Build Go Automation Service

```bash
cd ~/healthtrust/automation-service
go mod download
go build -o automation-service blockchain.go crypto.go database.go

# Verify binary exists
ls -la automation-service
# Should show the binary file
```

---

## STEP 11 — Install systemd Services (Auto-start on boot)

### 11.1 — Edit the service files to match your paths

The service files are in `~/healthtrust/deploy/`. We need to update the paths if your user is not `healthtrust` or your project is not at `/opt/healthtrust`.

```bash
# Create a working copy with correct paths
export APP_DIR="/home/healthtrust/healthtrust"
export APP_USER="healthtrust"

# ML Service
sudo tee /etc/systemd/system/healthtrust-ml.service > /dev/null <<EOF
[Unit]
Description=HealthTrust ML Service (FastAPI/Uvicorn)
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=simple
User=${APP_USER}
Group=${APP_USER}
WorkingDirectory=${APP_DIR}/ml-service
EnvironmentFile=${APP_DIR}/ml-service/.env
ExecStart=${APP_DIR}/ml-service/venv/bin/uvicorn main:app \\
    --host 127.0.0.1 \\
    --port 8000 \\
    --workers 2 \\
    --log-level info \\
    --access-log
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=healthtrust-ml

[Install]
WantedBy=multi-user.target
EOF

# Blockchain Service
sudo tee /etc/systemd/system/healthtrust-blockchain.service > /dev/null <<EOF
[Unit]
Description=HealthTrust Blockchain Service (Node.js/Express + MeshSDK)
After=network.target

[Service]
Type=simple
User=${APP_USER}
Group=${APP_USER}
WorkingDirectory=${APP_DIR}/server/blockchain-service
EnvironmentFile=${APP_DIR}/server/blockchain-service/.env
ExecStart=/usr/bin/npx ts-node src/app.ts
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=healthtrust-blockchain

[Install]
WantedBy=multi-user.target
EOF

# Go Automation Service
sudo tee /etc/systemd/system/healthtrust-go.service > /dev/null <<EOF
[Unit]
Description=HealthTrust Go Automation Service (Cardano Payout Poller)
After=network.target postgresql.service healthtrust-blockchain.service
Requires=postgresql.service

[Service]
Type=simple
User=${APP_USER}
Group=${APP_USER}
WorkingDirectory=${APP_DIR}/automation-service
EnvironmentFile=${APP_DIR}/.env
ExecStart=${APP_DIR}/automation-service/automation-service
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=healthtrust-go

[Install]
WantedBy=multi-user.target
EOF

# Reload and enable all
sudo systemctl daemon-reload
sudo systemctl enable healthtrust-ml healthtrust-blockchain healthtrust-go
```

---

## STEP 12 — Configure Nginx (Reverse Proxy + HTTPS)

### 12.1 — Without a domain (HTTP only — for testing)

```bash
sudo tee /etc/nginx/sites-available/healthtrust > /dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    client_max_body_size 20M;

    # Vue.js Frontend
    root /var/www/healthtrust;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;

        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 30d;
            add_header Cache-Control "public, immutable";
        }
    }

    # Python ML API (strip /api prefix)
    location /api/ {
        rewrite ^/api/(.*) /$1 break;
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 120s;
        proxy_connect_timeout 10s;
    }

    # Node.js Blockchain Service (strip /service prefix)
    location /service/ {
        rewrite ^/service/(.*) /$1 break;
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 120s;
        proxy_connect_timeout 10s;
    }

    # Block sensitive files
    location ~ /\. { deny all; }
    location ~* \.(env|sql|md|toml|mod|sum)$ { deny all; }
}
EOF

sudo ln -sf /etc/nginx/sites-available/healthtrust /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

### 12.2 — With a domain (HTTPS with Let's Encrypt)

After Step 12.1 is working with HTTP, add HTTPS:

```bash
# Install certbot
sudo apt install -y certbot python3-certbot-nginx

# Get SSL certificate (replace YOUR_DOMAIN)
sudo certbot --nginx -d YOUR_DOMAIN --non-interactive --agree-tos -m your-email@example.com

# Auto-renew (certbot adds a cron automatically, but verify)
sudo certbot renew --dry-run
```

Certbot will automatically modify your Nginx config to add SSL.

After SSL is enabled, rebuild the frontend with HTTPS URL:
```bash
cd ~/healthtrust/client
VITE_API_URL=https://YOUR_DOMAIN/api npm run build
sudo cp -r dist/* /var/www/healthtrust/
```

---

## STEP 13 — Configure Firewall (UFW)

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# DO NOT open 8000, 3001, or 5432 — they stay internal only
sudo ufw enable
sudo ufw status verbose
```

Expected output:
```
22/tcp     ALLOW IN    Anywhere    # SSH
80/tcp     ALLOW IN    Anywhere    # HTTP
443/tcp    ALLOW IN    Anywhere    # HTTPS
```

---

## STEP 14 — Start Everything! 🚀

```bash
# Start all 3 services
sudo systemctl start healthtrust-ml
sudo systemctl start healthtrust-blockchain
sudo systemctl start healthtrust-go

# Check they're all running
sudo systemctl status healthtrust-ml --no-pager
sudo systemctl status healthtrust-blockchain --no-pager
sudo systemctl status healthtrust-go --no-pager
sudo systemctl status nginx --no-pager
sudo systemctl status postgresql --no-pager
```

All should show **active (running)** in green.

---

## STEP 15 — Verify Everything Works

```bash
# Test ML API
curl -s http://127.0.0.1:8000/ | head -c 100
# Should return: {"status":"healthy","model":"Gradient Boosting"...}

# Test Blockchain Service
curl -s http://127.0.0.1:3001/health | head -c 100
# Should return: {"status":"healthy","network":"preprod"...}

# Test through Nginx (from server)
curl -s http://localhost/ | head -5
# Should return HTML: <!doctype html>...

curl -s http://localhost/api/ | head -c 100
# Should return ML health JSON

curl -s http://localhost/service/health | head -c 100
# Should return blockchain health JSON

# Test from outside (from your local machine)
curl -s http://YOUR_SERVER_IP/
curl -s http://YOUR_SERVER_IP/api/
curl -s http://YOUR_SERVER_IP/service/health
```

---

## 🔍 TROUBLESHOOTING

### Check service logs
```bash
sudo journalctl -u healthtrust-ml -f --no-pager          # ML service logs
sudo journalctl -u healthtrust-blockchain -f --no-pager   # Blockchain logs
sudo journalctl -u healthtrust-go -f --no-pager           # Go automation logs
sudo tail -f /var/log/nginx/error.log                      # Nginx errors
```

### Service won't start?
```bash
# See the exact error
sudo journalctl -u healthtrust-ml -n 50 --no-pager

# Common fixes:
# 1. Wrong path → check WorkingDirectory in service file
# 2. Permission denied → chown -R healthtrust:healthtrust ~/healthtrust
# 3. Port in use → ss -tlnp | grep 8000
# 4. Missing .env → check EnvironmentFile path in service file
```

### Database connection refused?
```bash
sudo systemctl status postgresql
# Check the DATABASE_URL in .env matches the user/password from Step 5
sudo -u postgres psql -d HealthTrust -c "SELECT count(*) FROM users;"
```

### Nginx 502 Bad Gateway?
```bash
# Backend not running — check the service
sudo systemctl status healthtrust-ml
sudo systemctl restart healthtrust-ml

# Test backend directly (bypass Nginx)
curl http://127.0.0.1:8000/
curl http://127.0.0.1:3001/health
```

### Go automation not processing payouts?
```bash
sudo journalctl -u healthtrust-go -f --no-pager
# Should show "Polling every 60 seconds..."
# If timeout errors: restart blockchain service first, then Go
sudo systemctl restart healthtrust-blockchain
sleep 10
sudo systemctl restart healthtrust-go
```

---

## 📊 USEFUL COMMANDS CHEAT SHEET

### Local Development (start.sh)

| Action | Command |
|--------|---------|
| Start everything + public link | `bash start.sh` |
| Start everything (localhost only) | `bash start.sh local` |
| Stop everything | `bash start.sh stop` |
| Restart everything | `bash start.sh restart` |
| Check all statuses | `bash start.sh status` |

### Server (systemd)

| Action | Command |
|--------|---------|
| Start all services | `sudo systemctl start healthtrust-ml healthtrust-blockchain healthtrust-go` |
| Stop all services | `sudo systemctl stop healthtrust-ml healthtrust-blockchain healthtrust-go` |
| Restart all services | `sudo systemctl restart healthtrust-ml healthtrust-blockchain healthtrust-go` |
| View ML logs | `sudo journalctl -u healthtrust-ml -f` |
| View Blockchain logs | `sudo journalctl -u healthtrust-blockchain -f` |
| View Go logs | `sudo journalctl -u healthtrust-go -f` |
| View Nginx logs | `sudo tail -f /var/log/nginx/healthtrust_error.log` |
| Check all statuses | `sudo systemctl status healthtrust-{ml,blockchain,go} nginx postgresql` |
| Check open ports | `ss -tlnp` |
| Check firewall | `sudo ufw status` |
| Rebuild frontend | `cd ~/healthtrust/client && VITE_API_URL=https://DOMAIN/api npm run build && sudo cp -r dist/* /var/www/healthtrust/` |
| Rebuild Go binary | `cd ~/healthtrust/automation-service && go build -o automation-service blockchain.go crypto.go database.go && sudo systemctl restart healthtrust-go` |
| Renew SSL cert | `sudo certbot renew` |
| Check DB | `psql postgresql://healthtrust_app:PASSWORD@localhost:5432/HealthTrust` |

---

## 🏗️ ARCHITECTURE ON SERVER

```
Internet
   │
   ▼
┌──────────────────────────────────┐
│  UFW Firewall                    │
│  Only ports: 22, 80, 443         │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│  Nginx (port 80/443)             │
│  ┌─────────┬──────────┬────────┐ │
│  │ /       │ /api/*   │/service│ │
│  │ Vue SPA │ Python   │ Node.js│ │
│  │ static  │ :8000    │ :3001  │ │
│  └─────────┴──────────┴────────┘ │
└──────────────────────────────────┘
           │
    ┌──────┴──────────────────┐
    │  Go Automation (no port)│
    │  Polls DB every 60s     │
    │  Calls :3001 for payouts│
    └──────┬──────────────────┘
           │
    ┌──────┴──────────────────┐
    │  PostgreSQL (port 5432) │
    │  localhost only          │
    └─────────────────────────┘
```

---

## ✅ DEPLOYMENT CHECKLIST

- [ ] SSH into server
- [ ] Install packages (Node 22, Go 1.21+, Python 3.10+, Nginx, PostgreSQL)
- [ ] Copy project files via rsync/scp
- [ ] Setup PostgreSQL (create DB, user, load schema, seed)
- [ ] Create all 3 `.env` files with correct secrets
- [ ] Build Vue frontend (`npm run build`)
- [ ] Setup Python venv + install requirements
- [ ] Install Node.js dependencies (`npm ci`)
- [ ] Build Go binary (`go build`)
- [ ] Install 3 systemd service files
- [ ] Configure Nginx (HTTP first, then HTTPS)
- [ ] Enable UFW firewall
- [ ] Start all services
- [ ] Test all endpoints
- [ ] Setup SSL with certbot (if using domain)
- [ ] Rebuild frontend with HTTPS URL
