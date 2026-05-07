#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${IMAGE_TAG:-}" ]]; then
  echo "IMAGE_TAG is required" >&2
  exit 1
fi

image="ghcr.io/${GITHUB_REPOSITORY_OWNER}/external-dns-t-cloud-public-webhook:${IMAGE_TAG}"

echo "Starting webhook container from image: ${image}"
echo "Using zone type: ${MATRIX_ZONE_TYPE}"
echo "Using cloud entry: ${OS_CLOUD}"

container_id="$(
  docker run -d --rm \
  --name webhook \
  -p 8888:8888 \
  -p 8080:8080 \
  -e OS_CLIENT_CONFIG_FILE=/etc/t-cloud-public/clouds.yaml \
  -e OS_CLOUD="${OS_CLOUD}" \
  -e ZONE_TYPE="${MATRIX_ZONE_TYPE}" \
  -e OS_ZONE_TYPE="${MATRIX_ZONE_TYPE}" \
  -v "$PWD/.ci/t-cloud-public:/etc/t-cloud-public:ro" \
  "${image}"
)"

echo "Started container id: ${container_id}"
docker ps -a --filter "id=${container_id}"

sleep 2
echo "Initial container logs:"
docker logs "${container_id}" || true
