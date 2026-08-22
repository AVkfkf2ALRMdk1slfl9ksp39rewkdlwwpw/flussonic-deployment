FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    procps \
    libcap2-bin \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Install the .deb packages
RUN apt-get update && \
    (dpkg -i *.deb || apt-get install -f -y) && \
    rm -rf /var/lib/apt/lists/*

# Setup configuration
RUN mkdir -p /etc/flussonic/ /var/lib/flussonic /var/log/flussonic /var/run/flussonic
COPY flussonic.conf /etc/flussonic/flussonic.conf

# Set environment variables
ENV HOME=/etc/flussonic
ENV PATH=/opt/flussonic/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
ENV LANG=C
ENV PROCNAME=flussonic
ENV STREAMER_SERVER_ID_PATH=/etc/flussonic/server.id
ENV STREAMER_LOG_DIR=/var/log/flussonic
ENV STREAMER_PID_PATH=/var/run/flussonic/pid

# Expose ports
EXPOSE 8080 1935

# Start Flussonic
WORKDIR /opt/flussonic
CMD ["/opt/flussonic/bin/run", "-noinput"]
