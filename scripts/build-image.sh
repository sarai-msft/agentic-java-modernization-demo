#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="agentic-modernization-demo:java17"

echo "Building container image with SBOM..."
docker buildx build \
    --tag "$IMAGE_TAG" \
    --sbom=true \
    --output type=local,dest=out \
    .

echo ""
echo "Image built: $IMAGE_TAG"
echo "SBOM and image layers available in ./out/"
