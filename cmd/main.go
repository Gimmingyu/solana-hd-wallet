package main

import (
	"github.com/joho/godotenv"
	"log"
	"os"
	"solana-hd-wallet/pkg/solana"
)

const (
	BasePath = "m/44'/501'/0'/0'"
)

func main() {
	log.Printf("Hierarchical Deterministic Wallet in Solana")

	if err := godotenv.Load(".env"); err != nil {
		log.Fatalf("failed to load env file : %v", err)
	}

	mnemonic := os.Getenv("MNEMONIC")

	seed := solana.MnemonicToSeed(mnemonic, "")

	log.Println(seed)

	key := solana.CreateMasterKey(seed)

	log.Println(key.PrivateKey)
	log.Println(key.ChainCode)

	child, err := solana.Derived(key.PrivateKey, "")
	if err != nil {
		log.Fatalf("failed to derive child key : %v", err)
	}

	log.Println(child.PrivateKey)
	log.Println(child.ChainCode)
}
