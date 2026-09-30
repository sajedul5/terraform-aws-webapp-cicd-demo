#!/usr/bin/env bash
# Deploy the latest web app image on the EC2 host.
# Usage: ./deploy.sh <image> [tag]
#   e.g. ./deploy.sh sajedul5/webapp-demo latest
set -euo pipefail

IMAGE="${1:-sajedul5/webapp-demo}"
TAG="${2:-latest}"
CONTAINER_NAME="webapp-demo"
HOST_PORT=8080
CONTAINER_PORT=80

echo "==> Pulling ${IMAGE}:${TAG}"
docker pull "${IMAGE}:${TAG}"

if docker ps -a --format '{{.Names}}' | grep -wq "${CONTAINER_NAME}"; then
  echo "==> Stopping old container"
  docker stop "${CONTAINER_NAME}" || true
  echo "==> Removing old container"
  docker rm "${CONTAINER_NAME}" || true
fi

echo "==> Starting new container"
docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart unless-stopped \
  -p "${HOST_PORT}:${CONTAINER_PORT}" \
  "${IMAGE}:${TAG}"

echo "==> Health check"
for i in $(seq 1 15); do
  if curl -fs "http://localhost:${HOST_PORT}/health" > /dev/null; then
    echo "==> Deployment successful 🚀"
    echo "==> Cleaning up old images"
    docker image prune -af --filter "until=24h" > /dev/null || true
    docker ps --filter "name=${CONTAINER_NAME}"
    exit 0
  fi
  sleep 2
done

echo "!! Health check failed"
docker logs "${CONTAINER_NAME}" --tail 50
exit 1
