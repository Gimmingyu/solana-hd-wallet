package main

import (
	"github.com/joho/godotenv"
	"log"
	"solana-hd-wallet/internal"
)

func main() {
	log.Printf("Hierarchical Deterministic Wallet in Solana")

	if err := godotenv.Load(".env"); err != nil {
		log.Fatalf("failed to load env file : %v", err)
	}

	internal.Bootstrap()
}