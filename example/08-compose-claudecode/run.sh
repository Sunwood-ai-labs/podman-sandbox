#!/bin/bash
# Claude Code + Alibaba Qwen 統合例
# https://www.alibabacloud.com/help/en/model-studio/claude-code

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "=== Claude Code + Alibaba Qwen 統合例 ==="

# .env ファイルの確認
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo ".env ファイルを作成 (.env.example からコピー)..."
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
    echo ""
    echo "⚠️  .env ファイルを編集して ALIBABA_API_KEY を設定してください!"
    echo "   https://dashscope.console.aliyun.com/ から取得 (Singapore リージョン)"
    echo ""
    exit 1
fi

# API キーが設定されているか確認
source "$SCRIPT_DIR/.env"
if [ -z "$ALIBABA_API_KEY" ] || [[ "$ALIBABA_API_KEY" == *"your-"* ]]; then
    echo "エラー: ALIBABA_API_KEY が設定されていません"
    echo ".env ファイルを編集して有効な API キーを設定してください"
    exit 1
fi

echo "1. イメージをビルド..."
podman-compose -f "$SCRIPT_DIR/docker-compose.yml" build

echo ""
echo "2. ヘルプを表示..."
podman-compose -f "$SCRIPT_DIR/docker-compose.yml" run --rm claudecode --help | head -20

echo ""
echo "3. バージョン確認..."
podman-compose -f "$SCRIPT_DIR/docker-compose.yml" run --rm claudecode --version

echo ""
echo "=== Qwen モデルで Claude が実行できるか確認 ==="
echo ""
echo "4. Qwen にメッセージを送信..."
podman-compose -f "$SCRIPT_DIR/docker-compose.yml" run --rm \
    -e ANTHROPIC_MODEL=${CLAUDE_MODEL:-qwen3.5-plus} \
    claudecode -p "Say hello in Japanese" 2>&1 | head -50

echo ""
echo "=== 完了 ==="
echo ""
echo "インタラクティブモードで起動:"
echo "  cd $SCRIPT_DIR && podman-compose run -it claudecode"
echo ""
echo "モデルを指定して実行:"
echo "  podman-compose run --rm -e ANTHROPIC_MODEL=qwen3-coder-next claudecode -p \"Your prompt\""
echo ""
echo "利用可能なモデル:"
echo "  qwen3.5-plus    - 複雑なタスク向け (推奨)"
echo "  qwen3-coder-next - コーディング特化"
echo "  qwen-turbo      - 高速レスポンス"
echo ""
echo "クリーンアップ:"
echo "  ./cleanup.sh"
