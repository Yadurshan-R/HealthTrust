#!/bin/bash
# ============================================
# HealthTrust - Nginx Setup
# Run as root after setup-services.sh
# Usage: bash setup-nginx.sh [your-domain.com]
# ============================================

set -e

DOMAIN="${1:-_}"
APP_DIR="/home/healthtrust/model_1"

echo "============================================"
echo "🌐 HealthTrust Nginx Setup"
echo "============================================"

if [ "$DOMAIN" = "_" ]; then
    echo "⚠️  No domain provided. Using IP address."
    echo "   To use a domain later: bash setup-nginx.sh yourdomain.com"
    SERVER_NAME="_"
else
    echo "   Domain: $DOMAIN"
    SERVER_NAME="$DOMAIN"
fi

# Create Nginx config
cat > /etc/nginx/sites-available/healthtrust << EOF
server {
    listen 80;
    server_name $SERVER_NAME;

    # Frontend - Vue.js static files
    location / {
        root $APP_DIR/client/dist;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # ML API (Python/FastAPI)
    location /api/ {
        proxy_pass http://127.0.0.1:8000/api/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 120s;
        client_max_body_size 10M;
    }

    # Blockchain Service (Node.js)
    location /service/ {
        proxy_pass http://127.0.0.1:3001/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable site and remove default
ln -sf /etc/nginx/sites-available/healthtrust /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test and reload
nginx -t
systemctl reload nginx

echo ""
echo "✅ Nginx configured!"

if [ "$DOMAIN" != "_" ]; then
    echo ""
    echo "📋 Setting up SSL with Let's Encrypt..."
    certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN --redirect
    echo "✅ SSL configured!"
fi

echo ""
echo "============================================"
echo "🎉 HealthTrust is now live!"
if [ "$DOMAIN" != "_" ]; then
    echo "   URL: https://$DOMAIN"
else
    echo "   URL: http://$(curl -s ifconfig.me)"
fi
echo "============================================"
echo ""
