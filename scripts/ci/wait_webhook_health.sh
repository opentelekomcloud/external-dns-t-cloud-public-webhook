#!/usr/bin/env bash
set -euo pipefail

for _ in $(seq 1 60); do
  if curl -fsS http://127.0.0.1:8080/healthz >/dev/null; then
    exit 0
  fi
  sleep 2
done

echo "Webhook did not become healthy" >&2
exit 1
