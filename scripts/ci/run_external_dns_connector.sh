#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${TXT_OWNER_ID:-}" ]]; then
  echo "TXT_OWNER_ID is required" >&2
  exit 1
fi

connector_addr="${CONNECTOR_SOURCE_SERVER:-127.0.0.1:18080}"

./build/external-dns \
  --txt-owner-id "${TXT_OWNER_ID}" \
  --provider webhook \
  --source connector \
  --connector-source-server "${connector_addr}" \
  --policy sync \
  --log-level=debug \
  --once
