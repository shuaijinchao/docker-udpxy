#!/bin/sh

# Build udpxy command arguments
ARGS=""

# Port configuration (required)
if [ -n "${UDPXY_PORT}" ]; then
    ARGS="${ARGS} -p ${UDPXY_PORT}"
fi

# Verbose output (-v)
if [ "${UDPXY_VERBOSE}" = "true" ]; then
    ARGS="${ARGS} -v"
fi

# Subscription renewal interval (-M, in seconds)
if [ -n "${UDPXY_RENEW}" ] && [ "${UDPXY_RENEW}" != "0" ]; then
    ARGS="${ARGS} -M ${UDPXY_RENEW}"
fi

# Always add -T to run in foreground (required for Docker containers)
# -T means "do NOT run as a daemon", which keeps the process in foreground
ARGS="${ARGS} -T"

# If custom arguments are provided, use them directly (highest priority)
if [ $# -gt 0 ]; then
    exec /usr/local/bin/udpxy "$@"
else
    # Use arguments built from environment variables
    exec /usr/local/bin/udpxy ${ARGS}
fi
