FROM buildpack-deps as builder

ARG UDPXY_SRC_URL

ENV UDPXY_SRC_URL=${UDPXY_SRC_URL:-"http://www.udpxy.com/download/udpxy/udpxy-src.tar.gz"}

WORKDIR /tmp

RUN wget -O udpxy-src.tar.gz ${UDPXY_SRC_URL}

RUN tar -xzvf udpxy-src.tar.gz

RUN cd udpxy-* && make && make install

FROM debian:stable

# Copy compiled binaries
COPY --from=builder /usr/local/bin/udpxy /usr/local/bin/udpxy
COPY --from=builder /usr/local/bin/udpxrec /usr/local/bin/udpxrec

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
