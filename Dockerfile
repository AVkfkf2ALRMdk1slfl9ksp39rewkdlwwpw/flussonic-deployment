FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    ca-certificates \
    procps \
    libcap2-bin \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN apt-get update && \
    (dpkg -i *.deb || apt-get install -f -y) && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/flussonic /var/lib/flussonic /var/log/flussonic /var/run/flussonic \
    && chmod +x /app/start-flussonic.sh

ENV HOME=/etc/flussonic \
    PATH=/opt/flussonic/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin \
    LANG=C \
    PROCNAME=flussonic \
    STREAMER_SERVER_ID_PATH=/etc/flussonic/server.id \
    STREAMER_LOG_DIR=/var/log/flussonic \
    STREAMER_PID_PATH=/var/run/flussonic/pid

# Railway supplies PORT at runtime; the start script uses it for HTTP.
EXPOSE 8080 1935

ENTRYPOINT ["/app/start-flussonic.sh"]
