package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

// BlockchainService configuration
const BlockchainServiceURL = "http://127.0.0.1:3001"

// PayoutRequest matches the blockchain service API
type PayoutRequest struct {
	RecipientAddress string                 `json:"recipientAddress"`
	AmountLovelace   int64                  `json:"amountLovelace"`
	ClaimMetadata    map[string]interface{} `json:"claimMetadata"`
}

// BlockchainResponse from the blockchain service
type BlockchainResponse struct {
	Success     bool   `json:"success"`
	TxHash      string `json:"txHash"`
	ExplorerURL string `json:"explorerUrl"`
	Network     string `json:"network"`
	Timestamp   string `json:"timestamp"`
	Error       string `json:"error,omitempty"`
}

// TransactionDetails from Blockfrost
type TransactionDetails struct {
	TxHash         string                 `json:"txHash"`
	BlockHeight    int64                  `json:"blockHeight"`
	BlockHash      string                 `json:"blockHash"`
	BlockTimestamp string                 `json:"blockTimestamp"`
	Slot           int64                  `json:"slot"`
	Confirmations  int                    `json:"confirmations"`
	Size           int                    `json:"size"`
	Fees           string                 `json:"fees"`
	TotalOutput    string                 `json:"totalOutput"`
	Metadata       map[string]interface{} `json:"metadata"`
	Status         string                 `json:"status"`
	Network        string                 `json:"network"`
	ExplorerURL    string                 `json:"explorerUrl"`
}

// SubmitTransaction sends a payout transaction via the blockchain service
func SubmitTransaction(claim Claim, hashedUserID string) (string, error) {
	log.Printf("   🔗 Calling blockchain service...")

	// Convert ADA to lovelace (1 ADA = 1,000,000 lovelace)
	lovelace := int64(claim.AmountBilled * 1_000_000)

	// Prepare claim metadata
	metadata := map[string]interface{}{
		"claim_id":     claim.ID,
		"user_id":      claim.UserID,
		"amount":       claim.AmountBilled,
		"ml_status":    claim.MLStatus,
		"claim_type":   "healthcare",
		"patient_name": claim.UserName,
		"hashed_id":    hashedUserID,
	}

	// Build request
	payload := PayoutRequest{
		RecipientAddress: claim.WalletAddress,
		AmountLovelace:   lovelace,
		ClaimMetadata:    metadata,
	}

	// Convert to JSON
	jsonData, err := json.Marshal(payload)
	if err != nil {
		return "", fmt.Errorf("failed to marshal request: %w", err)
	}

	log.Printf("   📤 Sending %d lovelace (%.2f ADA) to %s",
		lovelace, claim.AmountBilled, claim.WalletAddress[:20]+"...")

	// Make HTTP POST request (120s timeout: TX build + sign + submit to Cardano)
	client := &http.Client{Timeout: 120 * time.Second}
	resp, err := client.Post(
		BlockchainServiceURL+"/api/payout-transaction",
		"application/json",
		bytes.NewBuffer(jsonData),
	)
	if err != nil {
		return "", fmt.Errorf("failed to call blockchain service: %w", err)
	}
	defer resp.Body.Close()

	// Parse response
	var result BlockchainResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return "", fmt.Errorf("failed to decode response: %w", err)
	}

	// Check for errors
	if !result.Success {
		return "", fmt.Errorf("blockchain service error: %s", result.Error)
	}

	log.Printf("   ✅ Transaction submitted to Cardano %s network", result.Network)
	log.Printf("   🔍 Explorer: %s", result.ExplorerURL)

	// Store blockchain transaction in database
	if err := StoreBlockchainTransaction(result.TxHash, claim.ID, result.ExplorerURL); err != nil {
		log.Printf("   ⚠️ Failed to store blockchain transaction: %v", err)
	}

	return result.TxHash, nil
}

// StoreBlockchainTransaction saves the transaction record
func StoreBlockchainTransaction(txHash string, claimID int, explorerURL string) error {
	query := `
		INSERT INTO blockchain_transactions 
		(tx_hash, claim_id, status, network, explorer_url, fetched_at)
		VALUES ($1, $2, 'pending', 'preprod', $3, NOW())
		ON CONFLICT (tx_hash) DO NOTHING
	`

	_, err := db.Exec(query, txHash, claimID, explorerURL)
	if err != nil {
		return fmt.Errorf("failed to store blockchain tx: %w", err)
	}

	return nil
}

// GetTransactionDetails fetches transaction details from blockchain service
func GetTransactionDetails(txHash string) (*TransactionDetails, error) {
	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Get(BlockchainServiceURL + "/api/transaction/" + txHash)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch transaction: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("transaction not found: %d", resp.StatusCode)
	}

	var details TransactionDetails
	if err := json.NewDecoder(resp.Body).Decode(&details); err != nil {
		return nil, fmt.Errorf("failed to decode transaction: %w", err)
	}

	return &details, nil
}

// UpdateTransactionConfirmations updates confirmations for pending transactions
func UpdateTransactionConfirmations() {
	query := `
		SELECT tx_hash FROM blockchain_transactions 
		WHERE status = 'pending' 
		ORDER BY fetched_at DESC 
		LIMIT 10
	`

	rows, err := db.Query(query)
	if err != nil {
		log.Printf("Failed to query pending transactions: %v", err)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var txHash string
		if err := rows.Scan(&txHash); err != nil {
			continue
		}

		// Fetch latest details
		details, err := GetTransactionDetails(txHash)
		if err != nil {
			log.Printf("Failed to fetch TX %s: %v", txHash[:10], err)
			continue
		}

		// Update blockchain_transactions table
		updateQuery := `
			UPDATE blockchain_transactions
			SET confirmations = $1,
			    status = $2,
			    block_height = $3,
			    block_timestamp = $4,
			    slot = $5,
			    size = $6,
			    gas_fees = $7::bigint,
			    total_output = $8::bigint,
			    updated_at = NOW()
			WHERE tx_hash = $9
		`

		_, err = db.Exec(updateQuery,
			details.Confirmations,
			details.Status,
			details.BlockHeight,
			details.BlockTimestamp,
			details.Slot,
			details.Size,
			details.Fees,
			details.TotalOutput,
			txHash,
		)

		if err != nil {
			log.Printf("Failed to update TX %s: %v", txHash[:10], err)
		} else if details.Confirmations > 0 {
			log.Printf("✓ TX %s: %d confirmations (%s)",
				txHash[:10], details.Confirmations, details.Status)

			// Also update claims table with block_height
			SyncBlockHeightToClaim(txHash, details.BlockHeight)
		}
	}
}

// SyncBlockHeightToClaim updates the claims table with block_height from blockchain transaction
func SyncBlockHeightToClaim(txHash string, blockHeight int64) {
	query := `
		UPDATE claims
		SET block_height = $1
		WHERE tx_hash = $2 AND block_height IS NULL
	`

	result, err := db.Exec(query, blockHeight, txHash)
	if err != nil {
		log.Printf("Failed to sync block_height to claim: %v", err)
		return
	}

	rows, _ := result.RowsAffected()
	if rows > 0 {
		log.Printf("   ↳ Synced block_height %d to claim", blockHeight)
	}
}
