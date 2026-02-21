# 🚀 HealthTrust — Production Deployment Guide (Single Linux Server via SSH)

> **Author:** Senior DevOps & Security Specialist  
> **Date:** February 2026  
> **Stack:** Vue.js (Frontend) · Python/FastAPI (ML Service) · Go (Automation Service) · Node.js/Express (Blockchain Service) · PostgreSQL · Nginx · Cardano Preprod

---

## 📐 Architecture Overview (After Full Codebase Analysis)

```
┌─────────────────────────────────────────────────────────────────────┐
│                        INTERNET (Public)                            │
│                     ┌──────────────┐                                │
│                     │   Client      │                               │
│                     │   Browser     │                               │
│                     └──────┬───────┘                                │
│                            │ HTTPS (443) / HTTP (80)                │
│                            ▼                                        │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    NGINX (Reverse Proxy)                     │    │
│  │  0.0.0.0:80  → redirect to 443                              │    │
│  │  0.0.0.0:443 → TLS termination                              │    │
│  │                                                              │    │
│  │  /           → /var/www/healthtrust/dist  (Vue static build) │    │
│  │  /api/       → 127.0.0.1:8000  (Python FastAPI)             │    │
│  │  /service/   → 127.0.0.1:3001  (Node.js Blockchain Svc)     │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                            │                                        │
│         ┌──────────────────┼──────────────────┐                     │
│         ▼                  ▼                  ▼                     │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────┐            │
│  │ Python/ML   │  │ Node.js      │  │ Go Automation   │            │
│  │ FastAPI     │  │ Blockchain   │  │ Service         │            │
│  │ 127.0.0.1   │  │ 127.0.0.1   │  │ (no HTTP port)  │            │
│  │ :8000       │  │ :3001        │  │ polls DB every  │            │
│  │             │  │              │  │ 60 seconds      │            │
│  └──────┬──────┘  └──────┬───────┘  └────────┬────────┘            │
│         │                │                    │                     │
│         │     ┌──────────┴────────┐           │                     │
│         │     │                   │           │                     │
│         ▼     ▼                   ▼           ▼                     │
│  ┌─────────────────────────────────────────────────────┐            │
│  │            PostgreSQL (127.0.0.1:5432)               │            │
│  │            Database: HealthTrust                      │            │
│  │            Only localhost connections                 │            │
│  └─────────────────────────────────────────────────────┘            │
│                                                                     │
│  ┌─────────────────────────────────────────────────────┐            │
│  │  UFW Firewall: ALLOW 22/tcp, 80/tcp, 443/tcp ONLY  │            │
│  └─────────────────────────────────────────────────────┘            │
└─────────────────────────────────────────────────────────────────────┘
```

### Service Inventory (from source analysis)

| Service | Language | Framework | Port | Listens On | Role |
|---------|----------|-----------|------|------------|------|
| **Frontend** | Vue 3 | Vite (build → static) | N/A (Nginx) | — | SPA served by Nginx |
| **ML Service** | Python 3 | FastAPI + Uvicorn | `8000` | `0.0.0.0` → **must change to `127.0.0.1`** | Fraud detection, user/claim CRUD, image verification |
| **Blockchain Service** | TypeScript | Express + MeshSDK | `3001` | `0.0.0.0` → **must change to `127.0.0.1`** | Cardano transaction submission via Blockfrost |
| **Go Automation** | Go 1.21 | stdlib (no HTTP server) | None | — | Polls DB every 60s, calls Blockchain Service internally |
| **PostgreSQL** | — | PostgreSQL | `5432` | `127.0.0.1` | Stores users, claims, payouts, blockchain TXs |

### Inter-Service Communication Map (from source)

```
Vue Frontend (browser)  ──HTTP──►  ML Service (:8000)
                                     │ /predict, /users/:wallet, /claims/:id/trigger-payout, /verify-images
                                     │
Go Automation           ──HTTP──►  Blockchain Service (:3001)
  (polls DB internally)              │ /api/payout-transaction, /api/transaction/:txHash
                                     │
Python ML Service       ──SQL───►  PostgreSQL (:5432)
Go Automation           ──SQL───►  PostgreSQL (:5432)
```

**Key findings from code:**
- `client/src/api.js`: Frontend calls `VITE_API_URL` (default `http://localhost:8000`) — endpoints: `/`, `/predict`, `/users/:wallet`, `/claims/:id/trigger-payout`, `/verify-images`, `/model/info`
- `automation-service/blockchain.go`: Go calls `http://localhost:3001/api/payout-transaction` and `/api/transaction/:txHash`
- `ml-service/database.py`: DB connection string `postgresql://yadu:Ashokan321@localhost:5432/HealthTrust` — **CRITICAL: this password is hardcoded and must be rotated**
- `ml-service/main.py` line 430: Uvicorn binds `host="0.0.0.0"` — **must change to `127.0.0.1`**
- CORS is `allow_origins=["*"]` in ML service — **must be locked down in production**

---

## 1️⃣ PORT AUDIT

### 🟢 PUBLIC PORTS (bind to `0.0.0.0`)

| Port | Protocol | Service | Reason |
|------|----------|---------|--------|
| **22** | TCP | SSH | Remote server management |
| **80** | TCP | Nginx | HTTP → HTTPS redirect |
| **443** | TCP | Nginx | HTTPS termination, serves all traffic |

### 🔴 PRIVATE PORTS (bind to `127.0.0.1` ONLY)

| Port | Protocol | Service | Why Private |
|------|----------|---------|-------------|
| **8000** | TCP | Python/FastAPI (ML) | Backend API — only Nginx should reach it |
| **3001** | TCP | Node.js/Express (Blockchain) | Internal service — only Go automation + Nginx call it |
| **5432** | TCP | PostgreSQL | Database — only Python + Go connect via localhost |

### ⚠️ Required Code Changes for Production

**`ml-service/main.py` (last line):**
```python
# BEFORE (INSECURE):
uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")

# AFTER (SECURE):
uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")
```

**`server/blockchain-service/src/app.ts` (last block):**
```typescript
// BEFORE (INSECURE):
app.listen(config.port, () => { ... });

// AFTER (SECURE):
app.listen(config.port, '127.0.0.1', () => { ... });
```

**`ml-service/main.py` (CORS):**
```python
# BEFORE (INSECURE):
allow_origins=["*"]

# AFTER (SECURE):
allow_origins=["https://yourdomain.com"]
```

**`client/src/api.js`:**
```javascript
// For production, set VITE_API_URL before build:
// VITE_API_URL=https://yourdomain.com/api
```

---

## 2️⃣ NGINX CONFIGURATION

### File: `/etc/nginx/sites-available/healthtrust`

```nginx
# ============================================================================
# HealthTrust — Production Nginx Configuration
# Serves Vue SPA, proxies /api → Python ML, /service → Blockchain
# ============================================================================

# Rate limiting zones
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=general:10m rate=30r/s;

# HTTP → HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name yourdomain.com www.yourdomain.com;

    # ACME challenge for Let's Encrypt
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

# Main HTTPS server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    # ---------- TLS (Let's Encrypt / Certbot) ----------
    ssl_certificate     /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5:!RC4;
    ssl_prefer_server_ciphers on;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    # ---------- Security Headers ----------
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self' https://cardano-preprod.blockfrost.io;" always;

    # ---------- Logging ----------
    access_log /var/log/nginx/healthtrust_access.log;
    error_log  /var/log/nginx/healthtrust_error.log;

    # ---------- Client body size (for image uploads to /verify-images) ----------
    client_max_body_size 20M;

    # ==========================================================================
    # ROUTE 1: Vue.js Frontend (Static Build)
    # ==========================================================================
    root /var/www/healthtrust/dist;
    index index.html;

    location / {
        limit_req zone=general burst=20 nodelay;
        try_files $uri $uri/ /index.html;

        # Cache static assets aggressively
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 30d;
            add_header Cache-Control "public, immutable";
        }
    }

    # ==========================================================================
    # ROUTE 2: /api → Python FastAPI ML Service (127.0.0.1:8000)
    # ==========================================================================
    # Maps: /api/predict → :8000/predict
    #        /api/users/... → :8000/users/...
    #        /api/claims/... → :8000/claims/...
    #        /api/verify-images → :8000/verify-images
    #        /api/model/info → :8000/model/info
    # ==========================================================================
    location /api/ {
        limit_req zone=api_limit burst=10 nodelay;

        # Strip /api prefix — FastAPI routes don't have /api
        rewrite ^/api/(.*) /$1 break;

        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Timeouts for image verification (GPT-4o API calls can be slow)
        proxy_read_timeout 120s;
        proxy_connect_timeout 10s;
        proxy_send_timeout 60s;
    }

    # ==========================================================================
    # ROUTE 3: /service → Node.js Blockchain Service (127.0.0.1:3001)
    # ==========================================================================
    # Maps: /service/health → :3001/health
    #        /service/api/payout-transaction → :3001/api/payout-transaction
    #        /service/api/transaction/:txHash → :3001/api/transaction/:txHash
    #        /service/api/balance → :3001/api/balance
    # NOTE: The Go automation calls :3001 directly on localhost, so this
    #       route is for admin/monitoring only. You may choose to NOT
    #       expose this publicly and remove this block entirely.
    # ==========================================================================
    location /service/ {
        limit_req zone=api_limit burst=5 nodelay;

        # Strip /service prefix
        rewrite ^/service/(.*) /$1 break;

        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 60s;
        proxy_connect_timeout 10s;
    }

    # ---------- Block sensitive files ----------
    location ~ /\. {
        deny all;
    }

    location ~* \.(env|sql|md|toml|mod|sum)$ {
        deny all;
    }
}
```

### Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/healthtrust /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

### Get TLS certificate (Let's Encrypt):
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

---

## 3️⃣ PROCESS MANAGEMENT (systemd)

### A. Python ML Service — `/etc/systemd/system/healthtrust-ml.service`

```ini
[Unit]
Description=HealthTrust ML Service (FastAPI/Uvicorn)
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=simple
User=healthtrust
Group=healthtrust
WorkingDirectory=/opt/healthtrust/ml-service
EnvironmentFile=/opt/healthtrust/.env
ExecStart=/opt/healthtrust/ml-service/venv/bin/uvicorn main:app \
    --host 127.0.0.1 \
    --port 8000 \
    --workers 2 \
    --log-level info \
    --access-log
Restart=always
RestartSec=5
StartLimitIntervalSec=60
StartLimitBurst=5

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/healthtrust/ml-service
PrivateTmp=true

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=healthtrust-ml

[Install]
WantedBy=multi-user.target
```

### B. Go Automation Service — `/etc/systemd/system/healthtrust-go.service`

```ini
[Unit]
Description=HealthTrust Go Automation Service (Cardano Payout Poller)
After=network.target postgresql.service healthtrust-blockchain.service
Requires=postgresql.service

[Service]
Type=simple
User=healthtrust
Group=healthtrust
WorkingDirectory=/opt/healthtrust/automation-service
EnvironmentFile=/opt/healthtrust/.env
ExecStart=/opt/healthtrust/automation-service/automation-service
Restart=always
RestartSec=10
StartLimitIntervalSec=60
StartLimitBurst=5

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/healthtrust/automation-service
PrivateTmp=true

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=healthtrust-go

[Install]
WantedBy=multi-user.target
```

### C. Node.js Blockchain Service — `/etc/systemd/system/healthtrust-blockchain.service`

```ini
[Unit]
Description=HealthTrust Blockchain Service (Node.js/Express + MeshSDK)
After=network.target

[Service]
Type=simple
User=healthtrust
Group=healthtrust
WorkingDirectory=/opt/healthtrust/server/blockchain-service
EnvironmentFile=/opt/healthtrust/.env
ExecStart=/usr/bin/node -r ts-node/register src/app.ts
Restart=always
RestartSec=5
StartLimitIntervalSec=60
StartLimitBurst=5

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/healthtrust/server/blockchain-service
PrivateTmp=true

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=healthtrust-blockchain

[Install]
WantedBy=multi-user.target
```

### Enable and start all services:
```bash
sudo systemctl daemon-reload
sudo systemctl enable healthtrust-ml healthtrust-go healthtrust-blockchain
sudo systemctl start healthtrust-ml healthtrust-go healthtrust-blockchain

# Check status
sudo systemctl status healthtrust-ml healthtrust-go healthtrust-blockchain

# View logs
sudo journalctl -u healthtrust-ml -f
sudo journalctl -u healthtrust-go -f
sudo journalctl -u healthtrust-blockchain -f
```

---

## 4️⃣ FIREWALL LOCKDOWN (UFW)

```bash
# Reset to clean state (CAUTION: do this ONLY on fresh setup)
sudo ufw --force reset

# Default policies: deny all incoming, allow all outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (CRITICAL: do this BEFORE enabling UFW or you get locked out!)
sudo ufw allow 22/tcp comment 'SSH'

# Allow HTTP and HTTPS (Nginx only)
sudo ufw allow 80/tcp comment 'HTTP - Nginx'
sudo ufw allow 443/tcp comment 'HTTPS - Nginx'

# Enable firewall
sudo ufw enable

# Verify rules
sudo ufw status verbose
```

### Expected output:
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere          # SSH
80/tcp                     ALLOW IN    Anywhere          # HTTP - Nginx
443/tcp                    ALLOW IN    Anywhere          # HTTPS - Nginx
22/tcp (v6)                ALLOW IN    Anywhere (v6)     # SSH
80/tcp (v6)                ALLOW IN    Anywhere (v6)     # HTTP - Nginx
443/tcp (v6)               ALLOW IN    Anywhere (v6)     # HTTPS - Nginx
```

### What this blocks:
- ❌ Port 8000 (Python) — cannot be reached from outside
- ❌ Port 3001 (Blockchain) — cannot be reached from outside
- ❌ Port 5432 (PostgreSQL) — cannot be reached from outside
- ❌ Port 5173 (Vite dev) — not running in production

### Optional — restrict SSH to specific IPs:
```bash
# If you have a static IP, lock SSH down further:
sudo ufw delete allow 22/tcp
sudo ufw allow from YOUR_IP_ADDRESS to any port 22 proto tcp comment 'SSH from office'
```

---

## 5️⃣ DATABASE SECURITY (PostgreSQL)

### 5.1 Change the hardcoded password immediately

Your `ml-service/database.py` has:
```python
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://yadu:Ashokan321@localhost:5432/HealthTrust")
```
This password is **committed to Git**. Rotate it NOW:

```bash
# Connect to Postgres and change password
sudo -u postgres psql -c "ALTER USER yadu WITH PASSWORD 'new_strong_random_password_here';"
```

Then update `.env` and **never** hardcode DB credentials again.

### 5.2 Create a dedicated application user (least-privilege)

```sql
-- Connect as postgres superuser
sudo -u postgres psql

-- Create a restricted app user
CREATE USER healthtrust_app WITH PASSWORD 'GENERATE_A_64_CHAR_RANDOM_PASSWORD';

-- Grant only necessary permissions on the HealthTrust database
GRANT CONNECT ON DATABASE "HealthTrust" TO healthtrust_app;
\c HealthTrust
GRANT USAGE ON SCHEMA public TO healthtrust_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO healthtrust_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO healthtrust_app;

-- Make sure future tables also get permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO healthtrust_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO healthtrust_app;

-- Remove CREATE TABLE permission (app should NOT create/drop tables)
-- Migrations should be run manually by superuser
\q
```

### 5.3 Lock down `postgresql.conf`

```bash
sudo nano /etc/postgresql/*/main/postgresql.conf
```

Ensure:
```ini
# ONLY listen on localhost — NEVER on 0.0.0.0
listen_addresses = 'localhost'
port = 5432
```

### 5.4 Lock down `pg_hba.conf`

```bash
sudo nano /etc/postgresql/*/main/pg_hba.conf
```

Replace the default rules with:
```
# TYPE  DATABASE        USER                ADDRESS          METHOD

# Superuser for local admin tasks (via Unix socket)
local   all             postgres                             peer

# Application user — only from localhost, password required
host    HealthTrust     healthtrust_app     127.0.0.1/32     scram-sha-256
host    HealthTrust     healthtrust_app     ::1/128          scram-sha-256

# Block everything else
host    all             all                 0.0.0.0/0        reject
host    all             all                 ::/0             reject
```

Then restart:
```bash
sudo systemctl restart postgresql
```

### 5.5 Verify it's locked down

```bash
# From the server itself — should WORK:
psql -h 127.0.0.1 -U healthtrust_app -d HealthTrust

# From any external machine — should FAIL:
# (UFW blocks port 5432 AND pg_hba.conf rejects non-localhost)
```

---

## 6️⃣ ENVIRONMENT FILE

### `/opt/healthtrust/.env`

```bash
# =============================================================================
# HealthTrust Production Environment Variables
# PERMISSIONS: chmod 600 .env && chown healthtrust:healthtrust .env
# =============================================================================

# --- Database ---
DATABASE_URL=postgresql://healthtrust_app:YOUR_STRONG_PASSWORD@127.0.0.1:5432/HealthTrust

# --- ML Service ---
OPENAI_API_KEY=sk-your-openai-key-here

# --- Blockchain Service ---
PORT=3001
CARDANO_NETWORK=preprod
BLOCKFROST_API_KEY=preprodYOURKEY
TREASURY_MNEMONIC=your twenty four word mnemonic phrase here ...
TREASURY_ADDRESS=addr_test1qz...

# --- Frontend Build ---
VITE_API_URL=https://yourdomain.com/api
```

**Secure the file:**
```bash
sudo chmod 600 /opt/healthtrust/.env
sudo chown healthtrust:healthtrust /opt/healthtrust/.env
```

---

## 7️⃣ FULL DEPLOYMENT SCRIPT

```bash
#!/bin/bash
set -euo pipefail

# ============================================================================
# HealthTrust Production Deployment Script
# Run as root on a fresh Ubuntu 22.04+ server
# ============================================================================

DOMAIN="yourdomain.com"
APP_USER="healthtrust"
APP_DIR="/opt/healthtrust"
REPO="https://github.com/Yadurshan-R/HealthTrust.git"

echo "🚀 Starting HealthTrust production deployment..."

# --- 1. System packages ---
apt update && apt upgrade -y
apt install -y nginx postgresql postgresql-contrib python3 python3-pip python3-venv \
    golang-go nodejs npm ufw certbot python3-certbot-nginx git build-essential

# --- 2. Create application user ---
useradd --system --create-home --shell /bin/bash $APP_USER || true

# --- 3. Clone repository ---
mkdir -p $APP_DIR
git clone $REPO $APP_DIR || (cd $APP_DIR && git pull)
chown -R $APP_USER:$APP_USER $APP_DIR

# --- 4. Build Vue frontend ---
cd $APP_DIR/client
npm ci
VITE_API_URL=https://$DOMAIN/api npm run build
mkdir -p /var/www/healthtrust
cp -r dist/* /var/www/healthtrust/
chown -R www-data:www-data /var/www/healthtrust

# --- 5. Setup Python ML service ---
cd $APP_DIR/ml-service
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

# --- 6. Build Go automation service ---
cd $APP_DIR/automation-service
go build -o automation-service .

# --- 7. Setup Node.js blockchain service ---
cd $APP_DIR/server/blockchain-service
npm ci

# --- 8. Setup database ---
sudo -u postgres createdb HealthTrust || true
sudo -u postgres psql -d HealthTrust -f $APP_DIR/database/schema.sql
sudo -u postgres psql -d HealthTrust -f $APP_DIR/database/seed.sql
sudo -u postgres psql -d HealthTrust -f $APP_DIR/database/migrations/003_blockchain_transactions.sql
sudo -u postgres psql -d HealthTrust -f $APP_DIR/database/migrations/004_add_payout_date.sql
sudo -u postgres psql -d HealthTrust -f $APP_DIR/database/migrations/005_add_image_verification.sql

# --- 9. Copy systemd units ---
cp $APP_DIR/deploy/healthtrust-ml.service /etc/systemd/system/
cp $APP_DIR/deploy/healthtrust-go.service /etc/systemd/system/
cp $APP_DIR/deploy/healthtrust-blockchain.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable healthtrust-ml healthtrust-go healthtrust-blockchain

# --- 10. Copy Nginx config ---
cp $APP_DIR/deploy/healthtrust.nginx /etc/nginx/sites-available/healthtrust
ln -sf /etc/nginx/sites-available/healthtrust /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

# --- 11. Firewall ---
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# --- 12. TLS certificate ---
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m your@email.com

# --- 13. Start services ---
systemctl start healthtrust-ml healthtrust-go healthtrust-blockchain

echo "✅ HealthTrust deployed successfully!"
echo "   Frontend: https://$DOMAIN"
echo "   ML API:   https://$DOMAIN/api/"
echo "   Blockchain: https://$DOMAIN/service/health"
```

---

## 8️⃣ MONITORING & MAINTENANCE

### View service logs:
```bash
sudo journalctl -u healthtrust-ml -f --no-pager
sudo journalctl -u healthtrust-go -f --no-pager
sudo journalctl -u healthtrust-blockchain -f --no-pager
```

### Restart a service:
```bash
sudo systemctl restart healthtrust-ml
```

### Check if all services are running:
```bash
systemctl is-active healthtrust-ml healthtrust-go healthtrust-blockchain nginx postgresql
```

### Auto-renew TLS certificates:
```bash
# Certbot adds a systemd timer automatically. Verify:
sudo systemctl status certbot.timer
```

### Database backups:
```bash
# Add to crontab: daily backup at 2 AM
echo "0 2 * * * pg_dump -U postgres HealthTrust | gzip > /opt/healthtrust/backups/healthtrust_\$(date +\%Y\%m\%d).sql.gz" | sudo crontab -
```

---

## 9️⃣ SECURITY CHECKLIST

| # | Item | Status |
|---|------|--------|
| 1 | UFW enabled with only 22, 80, 443 open | ☐ |
| 2 | PostgreSQL `listen_addresses = 'localhost'` | ☐ |
| 3 | `pg_hba.conf` rejects non-localhost connections | ☐ |
| 4 | Database password rotated from hardcoded default | ☐ |
| 5 | Dedicated `healthtrust_app` DB user (no superuser) | ☐ |
| 6 | Python service bound to `127.0.0.1:8000` | ☐ |
| 7 | Node.js service bound to `127.0.0.1:3001` | ☐ |
| 8 | CORS restricted to your domain only | ☐ |
| 9 | `.env` file has `chmod 600` | ☐ |
| 10 | Treasury mnemonic in `.env`, not in code | ☐ |
| 11 | TLS certificate installed (Let's Encrypt) | ☐ |
| 12 | Security headers in Nginx | ☐ |
| 13 | `passwords.md` removed from repository | ☐ |
| 14 | Rate limiting on API routes | ☐ |
| 15 | Services run as non-root `healthtrust` user | ☐ |
