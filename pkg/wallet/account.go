package wallet

import (
	"github.com/portto/solana-go-sdk/pkg/hdwallet"
	"github.com/portto/solana-go-sdk/types"
	"github.com/tyler-smith/go-bip39"
)

const (
	BasePath = "m/44'/501'/0'/0'"
)

func NewFromMnemonic(mnemonic string) (*types.Account, error) {
	seed := bip39.NewSeed(mnemonic, "")
	derivedKey, err := hdwallet.Derived(BasePath, seed)
	if err != nil {
		return nil, err
	}
	account, err := types.AccountFromSeed(derivedKey.PrivateKey)
	if err != nil {
		return nil, err
	}
	return &account, err
}