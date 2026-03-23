#!/bin/bash
# Podman で Dockerfile をビルド・実行する例

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "=== Podman Dockerfile 例 ==="

# ビルド
echo "1. イメージをビルド..."
podman build -t my-curl-app "$SCRIPT_DIR"

# 実行
echo "2. コンテナを実行..."
podman run --rm my-curl-app

echo ""
echo "=== 完了 ==="
echo "イメージ削除: ./cleanup.sh"
