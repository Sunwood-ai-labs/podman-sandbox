#!/bin/bash
# Evolutionary Meeting Bot エントリーポイント

echo "=== 🧬 Evolutionary Meeting Bot Starting ==="
echo "Timezone: $TZ"
echo "Current time: $(date)"
echo ""

# GitHub 認証設定
if [ -n "$GH_TOKEN" ]; then
    echo "🔐 GitHub認証を設定中..."
    git config --global credential.helper store
    git config --global user.email "onizuka.renjiii@gmail.com"
    git config --global user.name "onizukarenjiii-droid"
    echo "https://${GH_TOKEN}@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    echo "✅ GitHub認証完了"
fi

# 初期ファイルがなければコピー
if [ ! -f /workspace/company/mission.md ]; then
    echo "📁 初期companyファイルを展開..."
    mkdir -p /workspace/company /workspace/meetings /workspace/deliverables
    cp -r /app/workspace/company/* /workspace/company/
fi

echo ""
echo "📅 Schedule: 毎時00分"
echo ""

# crond をバックグラウンドで起動
crond -b -l 2

echo "Bot is running."
tail -f /dev/null
