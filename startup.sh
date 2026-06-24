#!/bin/bash

set -e

HOST="veldariasmp.seedloaf.gg"
CONFIG="velocity.toml"

PORT=$(dig +short SRV _minecraft._tcp.${HOST} | awk '{print $3}')
IP=$(dig +short A ${HOST} | awk 'NR==1')

if [ -z "$PORT" ] || [ -z "$IP" ]; then
    echo "DNS lookup failed"
    exit 1
fi

echo "Backend: ${IP}:${PORT}"

sed -i -E \
"s|^([[:space:]]*veldariasmp = \")[^\"]*(\")$|\1${IP}:${PORT}\2|" \
"$CONFIG"

echo "velocity.toml updated"

exec java -Djava.net.preferIPv6Addresses=true -jar server.jar nogui
