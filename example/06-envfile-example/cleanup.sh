#!/bin/bash
# クリーンアップスクリプト

echo "イメージを削除..."
podman rmi -f env-demo 2>/dev/null

echo ".env ファイルを削除..."
rm -f "$(dirname "$0")/.env"

echo "完了!"
