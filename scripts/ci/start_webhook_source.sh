#!/usr/bin/env bash
set -euo pipefail

go build -o ./build/bin/external-dns-t-cloud-public-webhook ./cmd/webhook
ZONE_TYPE="${MATRIX_ZONE_TYPE}" ./build/bin/external-dns-t-cloud-public-webhook >/tmp/webhook.log 2>&1 &
