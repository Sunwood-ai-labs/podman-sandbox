#!/bin/bash
# Evolutionary Meeting Bot エントリーポイント

echo "=== 🧬 Evolutionary Meeting Bot Starting ==="
echo "Timezone: $TZ"
echo "Current time: $(date)"
echo ""
echo "📅 Schedule:"
echo "   CTO会議: 毎時00分"
echo "   CEO会議: 毎時30分"
echo "📄 Workspace: /workspace/"
echo "🏢 Company: /workspace/company/"
echo ""

# 初期化: company ファイルがなければコピー
if [ ! -f /workspace/company/mission.md ]; then
    echo "📁 初期companyファイルを展開..."
    mkdir -p /workspace/company
    cp -r /app/workspace/company/* /workspace/company/
fi

# 初回実行（起動直後にCTO会議を1回実行）
echo "Running initial CTO meeting..."
/app/scripts/cto-meeting.sh || echo "Initial meeting skipped (API key not configured?)"
echo ""

# cron をフォアグラウンドで実行
echo "Starting cron scheduler..."
echo "Next CTO meeting at :00"
echo "Next CEO meeting at :30"
exec crond -f -l 2
