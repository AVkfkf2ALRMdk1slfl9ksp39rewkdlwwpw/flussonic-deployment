#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-8080}"
RTMP_PORT="${RTMP_PORT:-1935}"
FLUSSONIC_USERNAME="${FLUSSONIC_USERNAME:-mura}"
: "${FLUSSONIC_PASSWORD:?Set FLUSSONIC_PASSWORD in Railway Variables}"

mkdir -p /etc/flussonic /var/lib/flussonic /var/log/flussonic /var/run/flussonic

cat > /etc/flussonic/flussonic.conf <<EOF
# Global settings:
http ${PORT};
rtmp ${RTMP_PORT};
pulsedb /var/lib/flussonic;
session_log /var/lib/flussonic;
edit_auth ${FLUSSONIC_USERNAME} '${FLUSSONIC_PASSWORD}';

# Components:
iptv;
EOF

exec /opt/flussonic/bin/run -noinput

# The process above must remain in the foreground so Railway can monitor it.
# shellcheck disable=SC2317
exit 1

