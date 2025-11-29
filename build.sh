#!/bin/bash

# Udpxy custom image build script

set -e

# Configuration variables
IMAGE_NAME="${IMAGE_NAME:-udpxy}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
REGISTRY="${REGISTRY:-}"  # Registry address, e.g., registry.example.com or docker.io/username
UDPXY_VERSION="${UDPXY_VERSION:-1.0.23-0-prod}"
UDPXY_SRC_URL="${UDPXY_SRC_URL:-https://sourceforge.net/projects/udpxy/files/udpxy/Chipmunk-1.0/udpxy.${UDPXY_VERSION}.tar.gz/download}"

# Build full image name
if [ -n "${REGISTRY}" ]; then
    FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
else
    FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"
fi

echo "=========================================="
echo "Building udpxy custom image"
echo "=========================================="
echo "Image name: ${FULL_IMAGE_NAME}"
echo "Udpxy version: ${UDPXY_VERSION}"
echo "Source URL: ${UDPXY_SRC_URL}"
echo "=========================================="
echo ""

# Build image
docker build \
    --build-arg UDPXY_VERSION="${UDPXY_VERSION}" \
    --build-arg UDPXY_SRC_URL="${UDPXY_SRC_URL}" \
    -t "${FULL_IMAGE_NAME}" \
    .

echo ""
echo "=========================================="
echo "Build completed!"
echo "=========================================="
echo ""
echo "Use the following command to run the container:"
echo "  docker run -d --name udpxy --network host \\"
echo "    -e UDPXY_PORT=10011 \\"
echo "    -e UDPXY_INTERFACE=eth0 \\"
echo "    ${FULL_IMAGE_NAME}"
echo ""

# Ask if push to registry
if [ -n "${REGISTRY}" ]; then
    read -p "Push to registry? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Pushing image..."
        docker push "${FULL_IMAGE_NAME}"
        echo "Push completed!"
    fi
fi
