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
    container_name: udpxy
    network_mode: host
    environment:
      - UDPXY_PORT=10011
      - UDPXY_VERBOSE=true
      - UDPXY_RENEW=300
    restart: unless-stopped
```

## Environment Variables

| Variable | Default | Description | Flag |
|----------|---------|-------------|------|
| `UDPXY_PORT` | `4022` | Port to listen on (required) | `-p` |
| `UDPXY_VERBOSE` | `false` | Enable verbose output (`true` to enable) | `-v` |
| `UDPXY_STATS` | `false` | Enable client statistics (`true` to enable) | `-S` |
| `UDPXY_LISTEN_ADDR` | (empty) | IPv4 address/interface to listen on (default: 0.0.0.0) | `-a` |
| `UDPXY_MCAST_ADDR` | (empty) | IPv4 address/interface of multicast source (default: 0.0.0.0) | `-m` |
| `UDPXY_MAX_CLIENTS` | (empty) | Max clients to serve (default: 3, max: 5000) | `-c` |
| `UDPXY_LOG_FILE` | (empty) | Log output to file (default: stderr) | `-l` |
| `UDPXY_BUFFER_SIZE` | (empty) | Buffer size for inbound data (e.g., 65536, 32Kb, 1Mb, default: 2048 bytes) | `-B` |
| `UDPXY_MAX_MSGS` | (empty) | Maximum messages to store in buffer (-1 = all, default: 1) | `-R` |
| `UDPXY_MAX_HOLD` | (empty) | Maximum time (sec) to hold data in buffer (-1 = unlimited, default: 1) | `-H` |
| `UDPXY_NICE` | (empty) | Nice value increment (default: 0) | `-n` |
| `UDPXY_RENEW` | `0` | Subscription renewal interval in seconds (0 = disabled, default: 0) | `-M` |

**Notes**:
- The `-T` flag (do NOT run as a daemon) is automatically added by the entrypoint script to ensure the process runs in foreground, which is required for Docker containers.
- Empty values mean the parameter will not be added (udpxy will use its default).
- The entrypoint script will print the command before starting udpxy for debugging purposes.

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

## Example Usage

In your `docker-compose.yaml`:

```yaml
services:
  udpxy:
    image: shuaijinchao/udpxy:latest
    container_name: udpxy
    network_mode: host
    environment:
      - UDPXY_PORT=10011
      - UDPXY_VERBOSE=true
      - UDPXY_RENEW=300
    restart: unless-stopped
```

No need to use `command` parameters anymore!

## License

This Docker image is based on the udpxy project. Please refer to the [udpxy website](https://www.udpxy.com/) for license information.
