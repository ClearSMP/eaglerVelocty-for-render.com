#!/bin/bash

set -e

HOST="veldariasmp.seedloaf.gg"
CONFIG="velocity.toml"

# バックエンドサーバーの情報を取得
BACKEND_PORT=$(dig +short SRV _minecraft._tcp.${HOST} | awk '{print $3}')
BACKEND_IP=$(dig +short A ${HOST} | awk 'NR==1')

if [ -z "$BACKEND_PORT" ] || [ -z "$BACKEND_IP" ]; then
    echo "DNS lookup failed"
    exit 1
fi

echo "Backend: ${BACKEND_IP}:${BACKEND_PORT}"

# velocity.toml のバックエンド設定を書き換え
sed -i -E \
"s|^([[:space:]]*veldariasmp = \")[^\"]*(\")$|\1${BACKEND_IP}:${BACKEND_PORT}\2|" \
"$CONFIG"

# Render が割り当てたポートで待ち受け
if [ -n "$PORT" ]; then
    echo "Render port: $PORT"

    sed -i -E \
    "s|^bind = \".*\"|bind = \"0.0.0.0:${PORT}\"|" \
    "$CONFIG"
fi

echo "velocity.toml updated"

exec java \
    -Djava.net.preferIPv6Addresses=true \
    -jar server.jar nogui
