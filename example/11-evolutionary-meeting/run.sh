#!/bin/bash
# Evolutionary Meeting Bot - 起動スクリプト

set -e

cd "$(dirname "$0")"

# .env チェック
if [ ! -f .env ]; then
    echo "❌ .env ファイルがありません"
    echo "💡 .env.example をコピーして設定してください:"
    echo "   cp .env.example .env"
    exit 1
fi

echo "🧬 Evolutionary Meeting Bot 起動中..."

# 既存コンテナを停止・削除
podman rm -f claude-evolution 2>/dev/null || true

# イメージビルド
podman build -t evolutionary-meeting:latest .

# workspace の所有者を 1000:1000 に変更（claudeユーザー用）
echo "🔐 workspace 権限設定中..."
sudo chown -R 1000:1000 ./workspace 2>/dev/null || chown -R 1000:1000 ./workspace 2>/dev/null || true

# コンテナ起動
podman run -d \
    --name claude-evolution \
    --env-file .env \
    -e TZ=Asia/Tokyo \
    -v ./workspace:/workspace \
    --restart unless-stopped \
    localhost/evolutionary-meeting:latest

echo ""
echo "✅ 起動完了"
echo ""
echo "📊 ログ確認:"
echo "   podman logs -f claude-evolution"
echo ""
echo "📁 CTO会議:"
echo "   ls workspace/meetings/cto/"
echo ""
echo "📁 CEO会議:"
echo "   ls workspace/meetings/ceo/"
echo ""
echo "🏢 会社情報:"
echo "   cat workspace/company/mission.md"
echo "   cat workspace/company/focus.md"
