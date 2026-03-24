#!/bin/bash
# Entrypoint for Evolutionary Meeting Bot

set -e

# crontab を登録
crontab /etc/cron.d/claude-cron

# 初期ログ
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🧬 Evolutionary Meeting Bot 起動"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 次回会議: 毎時0分"

# cron をフォアグラウンドで実行
exec cron -f -l 2
