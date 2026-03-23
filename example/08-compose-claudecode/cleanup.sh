#!/bin/bash
# クリーンアップスクリプト

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "=== Claude Code + Qwen 例のクリーンアップ ==="

# コンテナ停止・削除
echo "コンテナを停止・削除..."
podman-compose -f "$SCRIPT_DIR/docker-compose.yml" down --remove-orphans 2>/dev/null || true

# 個別にコンテナ削除 (念のため)
podman rm -f claudecode 2>/dev/null || true

# イメージ削除
echo "イメージを削除..."
podman rmi -f claudecode-compose:latest 2>/dev/null || true

echo "=== クリーンアップ完了 ==="
