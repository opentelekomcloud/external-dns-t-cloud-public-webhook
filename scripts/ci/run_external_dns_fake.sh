#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${ZONE_NAME:-}" ]]; then
  echo "ZONE_NAME is required" >&2
  exit 1
fi

if [[ -z "${TXT_OWNER_ID:-}" ]]; then
  echo "TXT_OWNER_ID is required" >&2
  exit 1
fi

./build/external-dns \
  --txt-owner-id "${TXT_OWNER_ID}" \
  --provider webhook \
  --source fake \
  --domain-filter "${ZONE_NAME}" \
  --policy sync \
  --log-level=debug \
  --once
