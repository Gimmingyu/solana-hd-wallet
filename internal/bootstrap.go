package internal

import (
	"flag"
	"log"
)

var (
	RpcEndpoint string
)

func Bootstrap() {

	network := flag.String("network", "mainnet", "testnet/mainnet/devnet")

	flag.Parse()

	switch *network {
	case DevNetwork:
		RpcEndpoint = ""
	case TestNetwork:
		RpcEndpoint = ""
	case MainNetwork:
		RpcEndpoint = ""
	default:
		log.Fatalf("invalid network")
	}

}