.PHONY: all build

PROJ_NAME = external-dns-t-cloud-public-webhook

all: build

build:
	go build -o build/bin/$(PROJ_NAME) ./cmd/webhook
