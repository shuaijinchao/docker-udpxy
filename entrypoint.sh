#!/bin/sh

# Build udpxy command arguments
ARGS=""

# Port configuration (required)
if [ -n "${UDPXY_PORT}" ]; then
    ARGS="${ARGS} -p ${UDPXY_PORT}"
fi

# Network interface configuration
if [ -n "${UDPXY_INTERFACE}" ]; then
    ARGS="${ARGS} -m ${UDPXY_INTERFACE}"
fi

# Verbose output (-v)
if [ "${UDPXY_VERBOSE}" = "true" ]; then
    ARGS="${ARGS} -v"
fi

# TTL configuration (-T)
if [ -n "${UDPXY_TTL}" ] && [ "${UDPXY_TTL}" != "0" ]; then
    ARGS="${ARGS} -T ${UDPXY_TTL}"
fi

# Subscription renewal interval (-M, in seconds)
if [ -n "${UDPXY_RENEW}" ] && [ "${UDPXY_RENEW}" != "0" ]; then
    ARGS="${ARGS} -M ${UDPXY_RENEW}"
fi

# If custom arguments are provided, use them directly (highest priority)
if [ $# -gt 0 ]; then
    exec /usr/local/bin/udpxy "$@"
else
    # Use arguments built from environment variables
    exec /usr/local/bin/udpxy ${ARGS}
fi
