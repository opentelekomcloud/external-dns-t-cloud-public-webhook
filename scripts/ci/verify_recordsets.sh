#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${ZONE_ID:-}" ]]; then
  echo "ZONE_ID is required" >&2
  exit 1
fi

a_count="$(openstack recordset list "${ZONE_ID}" --type A -f value -c id | wc -l | tr -d ' ')"
txt_count="$(openstack recordset list "${ZONE_ID}" --type TXT -f value -c id | wc -l | tr -d ' ')"

if [[ "${a_count}" -lt 10 ]]; then
  echo "Expected at least 10 A recordsets, got ${a_count}" >&2
  exit 1
fi

if [[ "${txt_count}" -lt 10 ]]; then
  echo "Expected at least 10 TXT recordsets, got ${txt_count}" >&2
  exit 1
fi
