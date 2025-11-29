# Udpxy Docker Image

A Docker image for [udpxy](https://www.udpxy.com/), a UDP-to-HTTP multicast traffic relay daemon, with support for environment variable configuration.

**Docker Hub**: `shuaijinchao/udpxy`

## Features

- ✅ Configure port via environment variable
- ✅ Support for other udpxy parameters via environment variables
- ✅ Compatible with original command-line usage
- ✅ Small image size (~15-20MB, Alpine-based)
- ✅ Multi-architecture support (amd64, arm64)

## Quick Start

### Using Docker Run

```bash
# Basic usage with default settings
docker run -d --name udpxy \
  --network host \
  --restart unless-stopped \
  shuaijinchao/udpxy:latest

# Custom port
docker run -d --name udpxy \
  --network host \
  --restart unless-stopped \
  -e UDPXY_PORT=10011 \
  shuaijinchao/udpxy:latest

# Full configuration example
docker run -d --name udpxy \
  --network host \
  --restart unless-stopped \
  -e UDPXY_PORT=10011 \
  -e UDPXY_VERBOSE=true \
  -e UDPXY_RENEW=300 \
  shuaijinchao/udpxy:latest
```

### Using Docker Compose

```yaml
version: '3.8'

services:
  udpxy:
    image: shuaijinchao/udpxy:latest
    container_name: iptv_udpxy
    network_mode: host
    environment:
      - UDPXY_PORT=10011
      - UDPXY_VERBOSE=true
      - UDPXY_RENEW=300
    restart: unless-stopped
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `UDPXY_PORT` | `4022` | Port for udpxy to listen on (equivalent to `-p` flag) |
| `UDPXY_VERBOSE` | `false` | Enable verbose output (equivalent to `-v` flag) |
| `UDPXY_RENEW` | `0` | Subscription renewal interval in seconds (equivalent to `-M` flag, `0` means not set) |

**Note**: The `-T` flag (do NOT run as a daemon) is automatically added by the entrypoint script to ensure the process runs in foreground, which is required for Docker containers.

## Command-Line Usage (Alternative)

You can still use command-line arguments directly, which will override environment variables:

```bash
docker run -d --name udpxy \
  --network host \
  --restart unless-stopped \
  shuaijinchao/udpxy:latest \
  -p 10011 -v -M 300
```

## View Help

```bash
docker run --rm shuaijinchao/udpxy:latest help
```

## Notes

1. **Network Mode**: udpxy requires `host` network mode to receive multicast streams

2. **Port Conflicts**: Ensure the specified port is not already in use

## Example: IPTV Project Usage

In your `docker-compose.yaml`:

```yaml
services:
  udpxy:
    image: shuaijinchao/udpxy:latest
    container_name: iptv_udpxy
    network_mode: host
    environment:
      - UDPXY_PORT=10011
    restart: unless-stopped
```

No need to use `command` parameters anymore!

## License

This Docker image is based on the udpxy project. Please refer to the [udpxy website](https://www.udpxy.com/) for license information.
