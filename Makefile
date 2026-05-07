.PHONY: all build lint vet test check

PROJ_NAME = external-dns-t-cloud-public-webhook
GO ?= go
GOLANGCI_LINT ?= golangci-lint

all: check build

build:
	mkdir -p build/bin
	$(GO) build -o build/bin/$(PROJ_NAME) ./cmd/webhook

lint:
	$(GOLANGCI_LINT) run ./...

vet:
	$(GO) vet ./...

test:
	$(GO) test ./...

check: lint vet test
