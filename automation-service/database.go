package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

// Claim represents a pending payout
type Claim struct {
	ID            int
	UserID        int
	UserName      string
	UserEmail     string
	WalletAddress string
	AmountBilled  float64
	MLStatus      string
	PayoutStatus  string
}

// Database connection
var db *sql.DB

// InitDB initializes the PostgreSQL connection
func InitDB(connStr string) error {
	var err error
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		return fmt.Errorf("failed to open database: %w", err)
	}

	// Test connection
	if err = db.Ping(); err != nil {
		return fmt.Errorf("failed to ping database: %w", err)
	}

	log.Println("✓ Database connected")
	return nil
}

// GetPendingPayouts fetches claims with payout_status = 'trigger'
func GetPendingPayouts() ([]Claim, error) {
	query := `
		SELECT 
			c.id, 
			c.user_id, 
			u.name, 
			u.email, 
			COALESCE(c.payout_address, u.wallet_address) as wallet_address,
			c.amount_billed,
			c.ml_status,
			c.payout_status
		FROM claims c
		JOIN users u ON c.user_id = u.id
		WHERE c.payout_status = 'trigger' AND c.ml_status = 'genuine'
		ORDER BY c.created_at ASC
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("failed to query pending payouts: %w", err)
	}
	defer rows.Close()

	var claims []Claim
	for rows.Next() {
		var claim Claim
		err := rows.Scan(
			&claim.ID,
			&claim.UserID,
			&claim.UserName,
			&claim.UserEmail,
			&claim.WalletAddress,
			&claim.AmountBilled,
			&claim.MLStatus,
			&claim.PayoutStatus,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan claim: %w", err)
		}
		claims = append(claims, claim)
	}

	return claims, nil
}

// UpdateClaimStatus updates the claim with tx_hash and completed status
func UpdateClaimStatus(claimID int, txHash string) error {
	query := `
		UPDATE claims 
		SET payout_status = 'completed', 
		    tx_hash = $1, 
		    payout_date = NOW(),
		    updated_at = NOW()
		WHERE id = $2
	`

	_, err := db.Exec(query, txHash, claimID)
	if err != nil {
		return fmt.Errorf("failed to update claim status: %w", err)
	}

	return nil
}

// InsertPublicPayout adds a record to the public_payouts table
func InsertPublicPayout(hashedUserID string, amount float64, txHash string) error {
	query := `
		INSERT INTO public_payouts (hashed_user_id, amount, tx_hash)
		VALUES ($1, $2, $3)
	`

	_, err := db.Exec(query, hashedUserID, amount, txHash)
	if err != nil {
		return fmt.Errorf("failed to insert public payout: %w", err)
	}

	return nil
}

// Main function
func main() {
	// Load environment variables
	if err := godotenv.Load("../.env"); err != nil {
		log.Println("Warning: .env file not found, using system environment variables")
	}

	// Initialize database
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL environment variable is required")
	}

	if err := InitDB(dbURL); err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	log.Println("🚀 Cardano Insurance Automation Service Started")
	log.Println("📡 Polling every 60 seconds for pending payouts...")

	// 60-second ticker
	ticker := time.NewTicker(60 * time.Second)
	defer ticker.Stop()

	// Run once immediately
	processPayouts()

	// Then run every 60 seconds
	for range ticker.C {
		processPayouts()

		// Also update confirmations for pending transactions
		UpdateTransactionConfirmations()
	}
}

func processPayouts() {
	log.Println("\n🔍 Checking for pending payouts...")

	// Get pending claims
	claims, err := GetPendingPayouts()
	if err != nil {
		log.Printf("❌ Error fetching pending payouts: %v\n", err)
		return
	}

	if len(claims) == 0 {
		log.Println("   No pending payouts found")
		return
	}

	log.Printf("   Found %d pending payout(s)\n", len(claims))

	// Process each claim
	for _, claim := range claims {
		log.Printf("\n💰 Processing Claim #%d", claim.ID)
		log.Printf("   User: %s (%s)", claim.UserName, claim.UserEmail)
		log.Printf("   Amount: ₳%.2f", claim.AmountBilled)
		log.Printf("   Wallet: %s", claim.WalletAddress)

		// Hash user ID for privacy
		hashedUserID := HashUserID(claim.UserName, claim.UserEmail)
		log.Printf("   Hashed ID: %s", hashedUserID)

		// Build and submit transaction
		txHash, err := SubmitTransaction(claim, hashedUserID)
		if err != nil {
			log.Printf("   ❌ Transaction failed: %v", err)
			continue
		}

		log.Printf("   ✅ Transaction submitted: %s", txHash)

		// Update database
		if err := UpdateClaimStatus(claim.ID, txHash); err != nil {
			log.Printf("   ⚠️ Failed to update claim status: %v", err)
		}

		if err := InsertPublicPayout(hashedUserID, claim.AmountBilled, txHash); err != nil {
			log.Printf("   ⚠️ Failed to insert public payout: %v", err)
		}

		log.Printf("   ✓ Claim #%d processed successfully", claim.ID)
	}

	log.Println("\n✅ Batch processing complete")
}
