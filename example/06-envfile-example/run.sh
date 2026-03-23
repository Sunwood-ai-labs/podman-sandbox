#!/bin/bash
# .env ファイル読み込み例

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "=== .env ファイル読み込み例 ==="

# .env ファイルの準備
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo ".env ファイルを作成 (.env.example からコピー)..."
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
fi

# ビルド
echo "1. イメージをビルド..."
podman build -t env-demo "$SCRIPT_DIR"

# 方法1: --env-file で読み込み
echo ""
echo "2. --env-file で .env を読み込み..."
podman run --rm --env-file "$SCRIPT_DIR/.env" env-demo

# 方法2: -e で上書き
echo ""
echo "3. -e で環境変数を上書き..."
podman run --rm --env-file "$SCRIPT_DIR/.env" -e APP_ENV=production env-demo

echo ""
echo "=== 完了 ==="
echo ""
echo "手動実行例:"
echo "  podman run --rm --env-file .env env-demo"
echo ""
echo "クリーンアップ:"
echo "  ./cleanup.sh"
