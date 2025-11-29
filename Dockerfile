FROM alpine:latest as builder

ARG UDPXY_VERSION=1.0.23-0-prod
ARG UDPXY_SRC_URL

# Install build dependencies
RUN apk update && \
    apk add --no-cache build-base wget

WORKDIR /tmp

# Download udpxy source code
# Use provided URL or default to SourceForge
ENV UDPXY_SRC_URL=${UDPXY_SRC_URL:-"https://sourceforge.net/projects/udpxy/files/udpxy/Chipmunk-1.0/udpxy.${UDPXY_VERSION}.tar.gz/download"}

RUN wget --no-check-certificate --tries=3 --timeout=30 --max-redirect=5 -O udpxy.tar.gz ${UDPXY_SRC_URL} && \
    tar -xzf udpxy.tar.gz && \
    ls -la && \
    test -d udpxy-1.0.23-0 || (echo "Failed to extract archive or directory not found" && exit 1)

# Build udpxy
# Add -Wno-format-truncation to suppress format-truncation warnings
# Only build udpxy (not udpxrec) to avoid compilation errors
# Remove udpxrec.c to prevent it from being compiled
RUN cd udpxy-1.0.23-0 && \
    mv udpxrec.c udpxrec.c.bak && \
    make CFLAGS="-W -Wall -Werror --pedantic -Wno-format-truncation" udpxy && \
    mv udpxrec.c.bak udpxrec.c

# Final stage: use Alpine for smaller image size
FROM alpine:latest

# Copy compiled binaries
COPY --from=builder /tmp/udpxy-1.0.23-0/udpxy /usr/local/bin/udpxy
# Note: udpxrec is not included due to compilation issues with newer GCC

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set default environment variables
ENV UDPXY_PORT=4022
ENV UDPXY_INTERFACE=eth0
ENV UDPXY_VERBOSE=false
ENV UDPXY_TTL=0
ENV UDPXY_RENEW=0

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
