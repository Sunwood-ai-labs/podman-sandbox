#!/bin/bash
# クリーンアップスクリプト

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

echo "サービスを停止..."
podman-compose down -v 2>/dev/null

echo "完了!"
