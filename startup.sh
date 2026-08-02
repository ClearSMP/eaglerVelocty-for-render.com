#!/bin/bash

set -e

HOST="mc.shadowflare.cloud-ip.cc"
CONFIG="velocity.toml"

# バックエンドサーバーの情報を取得
BACKEND_PORT=$(dig +short SRV _minecraft._tcp.${HOST} | awk '{print $3}')
BACKEND_IP=$(dig +short A ${HOST} | awk 'NR==1')

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

exec java -jar server.jar nogui
