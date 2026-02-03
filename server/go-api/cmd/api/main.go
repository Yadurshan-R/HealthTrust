package main

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables
	if err := godotenv.Load("../../.env"); err != nil {
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

	fmt.Println("🚀 Healthcare Insurance Automation Service")
	fmt.Println("============================================")
	fmt.Println()

	// Start payout processor
	StartPayoutProcessor()
}
