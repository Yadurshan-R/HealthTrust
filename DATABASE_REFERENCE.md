# PostgreSQL Database Reference Guide

Quick reference for checking and managing the HealthTrust database locally.

---

## 🔍 List All Databases

```bash
# As postgres user
sudo -u postgres psql -c "\l"

# Or enter psql and list
sudo -u postgres psql
\l
\q
```

---

## 📊 Connect to HealthTrust Database

### Option 1: Using yadu user
```bash
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust
```

### Option 2: Using postgres user
```bash
sudo -u postgres psql HealthTrust
```

---

## 🗂️ List All Tables

```bash
# Quick command
sudo -u postgres psql HealthTrust -c "\dt"

# Or inside psql
sudo -u postgres psql HealthTrust
\dt              # List tables
\dt+             # List tables with size
```

**Expected Tables:**
- `users`
- `claims`
- `blockchain_transactions`
- `public_payouts`

---

## 📋 View Table Structure

```bash
# Describe a specific table
sudo -u postgres psql HealthTrust -c "\d users"
sudo -u postgres psql HealthTrust -c "\d claims"
sudo -u postgres psql HealthTrust -c "\d blockchain_transactions"
sudo -u postgres psql HealthTrust -c "\d public_payouts"
```

---

## 🔢 Count Records in Tables

```bash
# Count users
sudo -u postgres psql HealthTrust -c "SELECT COUNT(*) as total_users FROM users;"

# Count claims
sudo -u postgres psql HealthTrust -c "SELECT COUNT(*) as total_claims FROM claims;"

# Count blockchain transactions
sudo -u postgres psql HealthTrust -c "SELECT COUNT(*) as total_transactions FROM blockchain_transactions;"

# All counts at once
sudo -u postgres psql HealthTrust << 'EOF'
SELECT COUNT(*) as users FROM users;
SELECT COUNT(*) as claims FROM claims;
SELECT COUNT(*) as transactions FROM blockchain_transactions;
SELECT COUNT(*) as payouts FROM public_payouts;
EOF
```

---

## 📖 View Table Data

### View Users
```bash
sudo -u postgres psql HealthTrust -c "SELECT * FROM users;"
```

### View Recent Claims
```bash
sudo -u postgres psql HealthTrust -c "SELECT id, user_id, amount_billed, ml_status, payout_status, created_at FROM claims ORDER BY created_at DESC LIMIT 10;"
```

### View Blockchain Transactions
```bash
sudo -u postgres psql HealthTrust -c "SELECT tx_hash, claim_id, confirmations, status FROM blockchain_transactions ORDER BY created_at DESC LIMIT 10;"
```

### View Public Payouts (Privacy-Preserved)
```bash
sudo -u postgres psql HealthTrust -c "SELECT * FROM public_payouts ORDER BY created_at DESC LIMIT 10;"
```

---

## 🔗 View Table Relationships

```bash
# See foreign keys and constraints
sudo -u postgres psql HealthTrust -c "\d+ claims"

# View all constraints
sudo -u postgres psql HealthTrust << 'EOF'
SELECT
    tc.table_name, 
    tc.constraint_name, 
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type;
EOF
```

---

## 👥 Check Database Users and Permissions

```bash
# List all database users
sudo -u postgres psql -c "\du"

# Check permissions on HealthTrust database
sudo -u postgres psql -c "\l HealthTrust"

# Check table permissions
sudo -u postgres psql HealthTrust -c "\dp"
sudo -u postgres psql HealthTrust -c "\dp users"
```

---

## 🔧 Interactive psql Session

```bash
# Start interactive session
sudo -u postgres psql HealthTrust

# Useful commands inside psql:
# \dt              - List tables
# \d tablename     - Describe table structure
# \du              - List users
# \l               - List databases
# \c dbname        - Connect to different database
# \q               - Quit psql
# \?               - Show all psql commands
# \h               - Show SQL command help
# \h SELECT        - Help for specific SQL command
```

---

## 💾 Backup and Restore

### Backup Database
```bash
# Backup entire database
sudo -u postgres pg_dump HealthTrust > healthtrust_backup_$(date +%Y%m%d).sql

# Backup specific table
sudo -u postgres pg_dump HealthTrust -t users > users_backup.sql
```

### Restore Database
```bash
# Restore from backup
sudo -u postgres psql HealthTrust < healthtrust_backup.sql
```

---

## 🗑️ Clean Up (BE CAREFUL!)

### Delete Old Data
```bash
# Delete claims older than 30 days
sudo -u postgres psql HealthTrust -c "DELETE FROM claims WHERE created_at < NOW() - INTERVAL '30 days';"

# Truncate specific table (removes all data)
sudo -u postgres psql HealthTrust -c "TRUNCATE TABLE blockchain_transactions CASCADE;"
```

### Drop Database (DANGEROUS!)
```bash
# Drop database (will delete all data!)
sudo -u postgres psql -c "DROP DATABASE IF EXISTS HealthTrust;"
```

---

## 📊 Useful Queries

### Claims by Status
```bash
sudo -u postgres psql HealthTrust << 'EOF'
SELECT 
    ml_status, 
    payout_status, 
    COUNT(*) as count 
FROM claims 
GROUP BY ml_status, payout_status;
EOF
```

### Recent Activity
```bash
sudo -u postgres psql HealthTrust << 'EOF'
SELECT 
    c.id,
    u.name as user_name,
    c.amount_billed,
    c.ml_status,
    c.payout_status,
    c.created_at
FROM claims c
JOIN users u ON c.user_id = u.id
ORDER BY c.created_at DESC
LIMIT 5;
EOF
```

### Blockchain Transaction Status
```bash
sudo -u postgres psql HealthTrust << 'EOF'
SELECT 
    status,
    COUNT(*) as count,
    AVG(confirmations) as avg_confirmations
FROM blockchain_transactions
GROUP BY status;
EOF
```

---

## 🔄 Database Connections

### Current Database URL
```bash
# From .env file
cat .env | grep DATABASE_URL
```

### Test Connection
```bash
# Test yadu user connection
PGPASSWORD=Ashokan321 psql -h localhost -U yadu -d HealthTrust -c "SELECT 1;"

# Test postgres user connection
sudo -u postgres psql HealthTrust -c "SELECT 1;"
```

---

## 📌 Quick Reference Card

| Command | Description |
|---------|-------------|
| `\l` | List databases |
| `\dt` | List tables |
| `\d tablename` | Describe table |
| `\du` | List users |
| `\c dbname` | Connect to database |
| `\q` | Quit psql |
| `\?` | Help |

---

## 🚨 Troubleshooting

### Can't connect to database
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start PostgreSQL
sudo systemctl start postgresql
```

### Permission denied
```bash
# Make sure user has proper permissions
sudo -u postgres psql HealthTrust -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO yadu;"
```

### Database doesn't exist
```bash
# Recreate database (will be empty)
sudo -u postgres psql -c "CREATE DATABASE \"HealthTrust\" OWNER yadu;"
```

---

## 🔑 Credentials

**Database:** HealthTrust  
**Username:** yadu  
**Password:** Ashokan321  
**Host:** localhost  
**Port:** 5432

**Connection String:**
```
postgresql://yadu:Ashokan321@localhost:5432/HealthTrust
```

**Alternative (postgres superuser):**
```
sudo -u postgres psql HealthTrust
```
