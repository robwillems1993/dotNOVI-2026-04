#!/bin/bash

IMAGE=${1:-ghcr.io/robwillems1993/dotnovi:latest}

echo "Deploying green environment..."

docker rm -f dotnovi-green 2>/dev/null || true

docker run -d \
  --name dotnovi-green \
  -p 3001:3000 \
  "$IMAGE"

echo "Running smoke test..."

sleep 5

if curl -f http://localhost:3001/health; then
  echo "Green environment is healthy"
  echo "Switch load balancer to green"

  docker stop dotnovi-blue 2>/dev/null || true

  echo "Blue environment stopped"
  echo "Deployment successful"
else
  echo "Smoke test failed"
  echo "Rolling back by stopping green environment"

  docker stop dotnovi-green

  exit 1
fi