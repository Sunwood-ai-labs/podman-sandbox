#!/bin/bash
# Claude Office Worker エントリーポイント

set -e

echo "=== 🏢 Claude Meeting Bot Starting ==="
echo "Timezone: $TZ"
echo "Current time: $(date)"
echo ""
echo "📅 Schedule: Every hour (0 * * * *)"
echo "📄 Workspace: /workspace/"
echo "🎯 Mission: Podman学習リポジトリの改善"
echo ""

# 初回実行（起動直後に1回実行）
echo "Running initial meeting..."
/app/scripts/office-work.sh

# cron をフォアグラウンドで実行
echo ""
echo "Starting cron scheduler..."
echo "Next meeting in 1 hour."
exec crond -f -l 2
