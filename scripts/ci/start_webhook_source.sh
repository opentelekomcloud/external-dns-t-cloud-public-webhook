#!/usr/bin/env bash
set -euo pipefail

mkdir -p ./build/bin
go build -o ./build/bin/external-dns-t-cloud-public-webhook ./cmd/webhook
nohup env \
  ZONE_TYPE="${MATRIX_ZONE_TYPE}" \
  ./build/bin/external-dns-t-cloud-public-webhook \
  >/tmp/webhook.log 2>&1 &

echo $! >/tmp/webhook.pid
