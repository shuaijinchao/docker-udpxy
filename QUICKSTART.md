# Quick Start Guide

This guide explains how to build your own udpxy Docker image and use it.

## Building the Image

### Method 1: Using the Build Script (Recommended)

```bash
# Set your registry and image name
export REGISTRY="your-registry.com/username"  # Optional: e.g., docker.io/username
export IMAGE_NAME="udpxy"
export IMAGE_TAG="latest"

# Run the build script
./build.sh
```

### Method 2: Direct Docker Build

```bash
# Build with default source URL
docker build -t your-registry/udpxy:latest .

# Build with custom source URL
docker build \
  --build-arg UDPXY_VERSION=1.0.23-0-prod \
  --build-arg UDPXY_SRC_URL=https://sourceforge.net/projects/udpxy/files/udpxy/Chipmunk-1.0/udpxy.1.0.23-0-prod.tar.gz/download \
  -t your-registry/udpxy:latest .
```

## Pushing to Registry

```bash
# Login to your registry (if needed)
docker login your-registry.com

# Push the image
docker push your-registry/udpxy:latest
```

## Using the Image

### Using Docker Run

```bash
# Basic usage
docker run -d --name udpxy \
  --network host \
  --restart unless-stopped \
  your-registry/udpxy:latest

# With environment variables
docker run -d --name udpxy \
  --network host \
  --restart unless-stopped \
  -e UDPXY_PORT=10011 \
  -e UDPXY_INTERFACE=eth0 \
  -e UDPXY_VERBOSE=true \
  -e UDPXY_RENEW=300 \
  your-registry/udpxy:latest
```

### Using Docker Compose

Create a `docker-compose.yaml`:

```yaml
version: '3.8'

services:
  udpxy:
    image: your-registry/udpxy:latest
    container_name: iptv_udpxy
    network_mode: host
    environment:
      - UDPXY_PORT=10011
      - UDPXY_INTERFACE=eth0
      - UDPXY_VERBOSE=true
      - UDPXY_RENEW=300
    restart: unless-stopped
```

Then start the service:

```bash
docker-compose up -d
```

## Verification

Test if the service is working:

```bash
# Check udpxy status (if verbose mode is enabled)
curl http://192.168.101.62:10011/status

# Test streaming (replace with actual multicast address)
curl http://192.168.101.62:10011/rtp/239.3.1.129:8008
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `UDPXY_PORT` | `4022` | Port for udpxy to listen on |
| `UDPXY_INTERFACE` | `eth0` | Network interface for receiving multicast streams |
| `UDPXY_VERBOSE` | `false` | Enable verbose output (`-v` flag) |
| `UDPXY_TTL` | `0` | TTL value (`-T` flag, `0` means not set) |
| `UDPXY_RENEW` | `0` | Subscription renewal interval in seconds (`-M` flag, `0` means not set) |

## Common Issues

### How to find network interface name?

```bash
ip addr show
# or
ifconfig
```

### How to view udpxy logs?

```bash
docker logs iptv_udpxy
# or with follow mode
docker logs -f iptv_udpxy
```

### How to test the custom image?

```bash
# Using environment variables
docker run --rm --network host \
  -e UDPXY_PORT=10011 \
  -e UDPXY_INTERFACE=eth0 \
  -e UDPXY_VERBOSE=true \
  your-registry/udpxy:latest

# Using command-line arguments (compatible with original usage)
docker run --rm --network host \
  your-registry/udpxy:latest \
  -p 10011 -m eth0 -v -M 300
```

## Build Script Usage

The `build.sh` script provides an easy way to build and optionally push the image:

```bash
# Basic build
./build.sh

# Build with custom registry
export REGISTRY="docker.io/username"
export IMAGE_NAME="udpxy"
export IMAGE_TAG="v1.0"
./build.sh
```

The script will:
1. Build the Docker image
2. Optionally prompt to push to registry (if REGISTRY is set)

## Image Details

- **Base Image**: Alpine Linux (latest)
- **Image Size**: ~15-20MB (much smaller than Debian-based images)
- **Multi-stage Build**: Yes (builds in Alpine, runs in minimal Alpine)
- **Supported Architectures**: linux/amd64, linux/arm64
- **Udpxy Version**: 1.0.23-0-prod

## Project Structure

```
docker-udpxy/
├── Dockerfile                 # Docker image definition (Alpine-based)
├── entrypoint.sh              # Startup script that builds command from env vars
├── build.sh                   # Build and push script
├── README.md                  # Usage documentation (for published image)
├── QUICKSTART.md              # Build and usage guide (this file)
├── docker-compose.example.yaml # Docker Compose example
└── .dockerignore              # Docker build ignore file
```
