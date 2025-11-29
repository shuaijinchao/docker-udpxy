#!/bin/sh

# Build udpxy command arguments
ARGS=""

# Port configuration (required, -p)
if [ -n "${UDPXY_PORT}" ]; then
    ARGS="${ARGS} -p ${UDPXY_PORT}"
fi

# Verbose output (-v)
if [ "${UDPXY_VERBOSE}" = "true" ]; then
    ARGS="${ARGS} -v"
fi

# Client statistics (-S)
if [ "${UDPXY_STATS}" = "true" ]; then
    ARGS="${ARGS} -S"
fi

# Listen address/interface (-a)
if [ -n "${UDPXY_LISTEN_ADDR}" ]; then
    ARGS="${ARGS} -a ${UDPXY_LISTEN_ADDR}"
fi

# Multicast source address/interface (-m)
if [ -n "${UDPXY_MCAST_ADDR}" ]; then
    ARGS="${ARGS} -m ${UDPXY_MCAST_ADDR}"
fi

# Max clients (-c)
if [ -n "${UDPXY_MAX_CLIENTS}" ] && [ "${UDPXY_MAX_CLIENTS}" != "0" ]; then
    ARGS="${ARGS} -c ${UDPXY_MAX_CLIENTS}"
fi

# Log file (-l)
if [ -n "${UDPXY_LOG_FILE}" ]; then
    ARGS="${ARGS} -l ${UDPXY_LOG_FILE}"
fi

# Buffer size (-B)
if [ -n "${UDPXY_BUFFER_SIZE}" ] && [ "${UDPXY_BUFFER_SIZE}" != "0" ]; then
    ARGS="${ARGS} -B ${UDPXY_BUFFER_SIZE}"
fi

# Maximum messages to store in buffer (-R, -1 = all)
if [ -n "${UDPXY_MAX_MSGS}" ]; then
    ARGS="${ARGS} -R ${UDPXY_MAX_MSGS}"
fi

# Maximum time to hold data in buffer (-H, in seconds, -1 = unlimited)
if [ -n "${UDPXY_MAX_HOLD}" ]; then
    ARGS="${ARGS} -H ${UDPXY_MAX_HOLD}"
fi

# Nice value increment (-n)
if [ -n "${UDPXY_NICE}" ] && [ "${UDPXY_NICE}" != "0" ]; then
    ARGS="${ARGS} -n ${UDPXY_NICE}"
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
    echo "Starting udpxy with custom arguments: /usr/local/bin/udpxy $@"
    exec /usr/local/bin/udpxy "$@"
else
    # Use arguments built from environment variables
    echo "Starting udpxy with command: /usr/local/bin/udpxy${ARGS}"
    exec /usr/local/bin/udpxy ${ARGS}
fi
