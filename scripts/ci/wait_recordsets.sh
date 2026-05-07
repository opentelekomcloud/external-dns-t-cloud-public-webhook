#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${ZONE_ID:-}" ]]; then
  echo "ZONE_ID is required" >&2
  exit 1
fi

for _ in $(seq 1 60); do
  pending="$(openstack recordset list "${ZONE_ID}" --status PENDING -f value -c id | wc -l | tr -d ' ')"
  if [[ "${pending}" == "0" ]]; then
    exit 0
  fi
  sleep 2
done

echo "Recordsets are still pending" >&2
exit 1
