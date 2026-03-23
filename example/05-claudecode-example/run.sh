#!/bin/bash
# ClaudeCode 内蔵コンテナのビルドと実行例

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "=== ClaudeCode 内蔵コンテナ例 ==="

# API キーの確認
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "エラー: ANTHROPIC_API_KEY 環境変数が設定されていません"
    echo "例: export ANTHROPIC_API_KEY=your-api-key"
    exit 1
fi

# ビルド
echo "1. イメージをビルド..."
podman build -t claudecode "$SCRIPT_DIR"

# ヘルプ表示
echo ""
echo "2. ヘルプを表示..."
podman run --rm claudecode --help | head -20

echo ""
echo "3. バージョン確認..."
podman run --rm claudecode --version

echo ""
echo "=== 完了 ==="
echo ""
echo "インタラクティブモードで起動:"
echo "  podman run -it --rm -e ANTHROPIC_API_KEY=\$ANTHROPIC_API_KEY -v \$(pwd):/workspace claudecode"
echo ""
echo "クリーンアップ:"
echo "  ./cleanup.sh"
