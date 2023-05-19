package solana

import (
	"github.com/portto/solana-go-sdk/pkg/hdwallet"
	"github.com/portto/solana-go-sdk/types"
	"github.com/tyler-smith/go-bip39"
)

const (
	BasePath = "m/44'/501'/0'/0'"
)

func MnemonicToSeed(mnemonic, password string) []byte {
	return bip39.NewSeed(mnemonic, "password")
}

func Derived(seed []byte, path string) (hdwallet.Key, error) {
	if path == "" {
		return hdwallet.Derived(BasePath, seed)
	}
	return hdwallet.Derived(path, seed)
}

func AccountFromSeed(privateKey []byte) (*types.Account, error) {
	account, err := types.AccountFromSeed(privateKey)
	if err != nil {
		return nil, err
	}
	return &account, err
}

func CreateMasterKey(seed []byte) hdwallet.Key {
	return hdwallet.CreateMasterKey(seed)
}
