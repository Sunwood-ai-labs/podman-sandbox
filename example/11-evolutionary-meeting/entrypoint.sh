#!/bin/bash
# Evolutionary Meeting Bot エントリーポイント

echo "=== 🧬 Evolutionary Meeting Bot Starting ==="
echo "Timezone: $TZ"
echo "Current time: $(date)"
echo ""

# ワークスペースの権限を設定
echo "🔐 ワークスペース権限を設定中..."
chown -R claude:claude /workspace /logs 2>/dev/null || true

# GitHub 認証設定
if [ -n "$GH_TOKEN" ]; then
    echo "🔐 GitHub認証を設定中..."
    mkdir -p ~claude
    git config --global credential.helper store
    git config --global user.email "onizuka.renjiii@gmail.com"
    git config --global user.name "onizukarenjiii-droid"
    echo "https://${GH_TOKEN}@github.com" > ~claude/.git-credentials
    chmod 600 ~claude/.git-credentials
    chown claude:claude ~claude/.git-credentials 2>/dev/null || true
    echo "✅ GitHub認証完了"
fi

# 初期ファイルがなければコピー
if [ ! -f /workspace/company/mission.md ]; then
    echo "📁 初期companyファイルを展開..."
    mkdir -p /workspace/company /workspace/meetings /workspace/deliverables
    cp -r /app/workspace/company/* /workspace/company/
    chown -R claude:claude /workspace 2>/dev/null || true
fi

echo ""
echo "📅 Schedule: 毎時00分"
echo ""

# root で crond を起動（claude ユーザーの crontab を使用）
echo "Starting cron daemon..."
crond -f -l 2
