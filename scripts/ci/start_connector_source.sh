#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${ZONE_NAME:-}" ]]; then
  echo "ZONE_NAME is required" >&2
  exit 1
fi

connector_addr="${CONNECTOR_SOURCE_SERVER:-127.0.0.1:18080}"

nohup env \
  ZONE_NAME="${ZONE_NAME}" \
  CONNECTOR_SOURCE_SERVER="${connector_addr}" \
  GOCACHE="${PWD}/.gocache" \
  go run ./cmd/ci-connector-source \
  >/tmp/connector-source.log 2>&1 &

echo $! >/tmp/connector-source.pid
echo "Started connector source on ${connector_addr}"
