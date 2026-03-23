#!/bin/bash
set -e

echo "Cleaning up freeze screenshot example..."

# 生成された画像を削除
rm -rf output/

# コンテナを削除
podman rm -f freeze-screenshot 2>/dev/null || true

# イメージを削除
podman rmi -f freeze-screenshot 2>/dev/null || true

echo "Cleanup complete!"
