#!/bin/bash

echo "Rolling back deployment..."

docker stop dotnovi-green 2>/dev/null || true
docker rm dotnovi-green 2>/dev/null || true

echo "Rollback completed"