GOCMD = go
SHELL = sh

DOCKER = docker

IMAGE = solana-hd-wallet
IMAGE_TAG = base

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

BUILD_DIR = build
GEN_DIR = gen
BINARY_NAME = appd
ENTRY = cmd/main.go

all: help

## Docker-build
docker-build: ## build docker image
	$(DOCKER) build -t $(IMAGE):$(IMAGE_TAG) .

## Vendor:
vendor: ## execute go mod vendor
	@$(GOCMD) mod vendor

## Build:
build: vendor  ## build
	@echo "${YELLOW}Compiling protobuf...${YELLOW}"
	@mkdir -p $(BUILD_DIR) $(GEN_DIR)
	@protoc --go_out=gen/ --go-grpc_out=gen/ -I proto/ proto/*.proto
	@echo "${CYAN}Compile done${CYAN}"
	@echo "${YELLOW}Build matching engine ...${YELLOW}"
	@GO111MODULE=on \
	CGO_ENABLED=0 \
	GOARCH=amd64 \
	$(GOCMD) build -mod vendor -o $(BUILD_DIR)/$(BINARY_NAME) $(ENTRY)
	@echo "${CYAN}Build done${CYAN}"


## Run test:
run-test: build ## testnet
	@./$(BUILD_DIR)/$(BINARY_NAME) --network=testnet

## Run dev:
run-dev: build ## devent
	@./$(BUILD_DIR)/$(BINARY_NAME) --network=devnet

## Run prod:
run-prod: build ## mainnet
	@./$(BUILD_DIR)/$(BINARY_NAME) --network=mainnet

## Help:
help: ## Show this help.
	@echo $(MAKEFILE_LIST)
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)


.PHONY: build help all vendor run docker-build