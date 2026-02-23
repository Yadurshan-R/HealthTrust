#!/bin/bash
# ============================================
# HealthTrust - Database Setup
# Run as root after setup-server.sh
# ============================================

set -e

echo "============================================"
echo "🗄️  HealthTrust Database Setup"
echo "============================================"

DB_NAME="HealthTrust"
DB_USER="healthtrust"
DB_PASS="HealthTrust_2026_Secure!"

# Create database user and database
echo ""
echo "📦 Creating database and user..."
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';" 2>/dev/null || echo "   User already exists"
sudo -u postgres psql -c "CREATE DATABASE \"$DB_NAME\" OWNER $DB_USER;" 2>/dev/null || echo "   Database already exists"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE \"$DB_NAME\" TO $DB_USER;"

# Run schema
echo ""
echo "📦 Running database schema..."
PGPASSWORD=$DB_PASS psql -U $DB_USER -d $DB_NAME -f /home/healthtrust/model_1/database/schema.sql

# Run migrations
echo ""
echo "📦 Running migrations..."
for migration in /home/healthtrust/model_1/database/migrations/*.sql; do
    echo "   Running: $(basename $migration)"
    PGPASSWORD=$DB_PASS psql -U $DB_USER -d $DB_NAME -f "$migration" 2>/dev/null || true
done

echo ""
echo "✅ Database setup complete!"
echo "   Database: $DB_NAME"
echo "   User: $DB_USER"
echo "   Password: $DB_PASS"
echo ""
