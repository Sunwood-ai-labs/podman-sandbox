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

# crond をバックグラウンドで起動
echo "Starting cron scheduler..."
crond -b -l 2

echo "Next CTO meeting at :00"
echo "Next CEO meeting at :30"
echo ""

# フォアグラウンドで待機
echo "Bot is running. Press Ctrl+C to stop."
tail -f /dev/null
