#!/bin/bash

# Cardano Insurance dApp - Local Setup Script
# Automates PostgreSQL database setup

set -e  # Exit on error

echo "=========================================="
echo "Cardano Insurance dApp - Database Setup"
echo "=========================================="

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL not found. Installing..."
    sudo apt update
    sudo apt install -y postgresql postgresql-contrib
    echo "✅ PostgreSQL installed"
else
    echo "✅ PostgreSQL already installed"
fi

# Start PostgreSQL service
echo ""
echo "Starting PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql
echo "✅ PostgreSQL service running"

# Create database and user
echo ""
echo "Creating database and user..."
sudo -u postgres psql <<EOF
-- Drop existing database if it exists
DROP DATABASE IF EXISTS "HealthTrust";
DROP USER IF EXISTS yadu;

-- Create new database and user
CREATE DATABASE "HealthTrust";
CREATE USER yadu WITH PASSWORD 'Ashokan321';
GRANT ALL PRIVILEGES ON DATABASE "HealthTrust" TO yadu;

-- Connect to database and grant permissions
\c "HealthTrust"
GRANT ALL ON SCHEMA public TO yadu;
EOF

echo "✅ Database and user created"

# Load schema
echo ""
echo "Loading database schema..."
sudo -u postgres psql HealthTrust < database/schema.sql
echo "✅ Schema loaded"

# Load seed data
echo ""
echo "Loading seed data..."
sudo -u postgres psql HealthTrust < database/seed.sql
echo "✅ Seed data loaded"

# Verify setup
echo ""
echo "=========================================="
echo "Verification:"
echo "=========================================="
sudo -u postgres psql HealthTrust -c "SELECT COUNT(*) as user_count FROM users;"
sudo -u postgres psql HealthTrust -c "SELECT name, wallet_address FROM users LIMIT 3;"

echo ""
echo "=========================================="
echo "✅ Database setup complete!"
echo "=========================================="
echo ""
echo "Connection details:"
echo "  Database: HealthTrust"
echo "  User: yadu"
echo "  Password: Ashokan321"
echo "  Host: localhost"
echo "  Port: 5432"
echo ""
echo "Connection string:"
echo "  postgresql://yadu:Ashokan321@localhost:5432/HealthTrust"
echo ""
echo "Next steps:"
echo "  1. Setup ML service: cd ml-service && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
echo "  2. Start ML service: cd ml-service && source venv/bin/activate && uvicorn main:app --reload"
echo "  3. Start frontend: cd frontend && npm run dev"
echo ""
