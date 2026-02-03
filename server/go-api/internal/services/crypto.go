package main

import (
	"crypto/sha256"
	"encoding/hex"

	"golang.org/x/crypto/blake2b"
)

// HashUserID creates a Blake2b-256 hash of (name + email) for privacy
func HashUserID(name, email string) string {
	// Combine name and email
	data := name + email

	// Create Blake2b-256 hash
	hash, err := blake2b.New256(nil)
	if err != nil {
		// Fallback to SHA-256 if Blake2b fails
		shaHash := sha256.Sum256([]byte(data))
		return hex.EncodeToString(shaHash[:])
	}

	hash.Write([]byte(data))
	return hex.EncodeToString(hash.Sum(nil))
}
