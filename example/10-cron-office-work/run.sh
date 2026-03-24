#!/bin/bash
set -e

echo "=== 🏢 Claude Meeting Bot ==="
echo ""
echo "1時間おきに定時会議を開いて、"
echo "マークダウン形式の議事録を出力します。"
echo ""

if [ ! -f .env ]; then
    echo "⚠️  .env ファイルが見つかりません"
    echo "  cp .env.example .env"
    exit 1
fi

mkdir -p reports workspace

echo "🔨 ビルド中..."
podman-compose build

echo ""
echo "🚀 起動中..."
podman-compose up -d

echo ""
sleep 5
podman ps | grep claude-meeting

echo ""
echo "📄 議事録: ./reports/meeting_YYYY-MM-DD.md"
echo "📋 ログ確認: podman logs -f claude-meeting"
echo ""
echo "🏢 定時会議ボット起動完了！"
