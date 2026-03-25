#!/bin/bash
# 定例会議

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M")
DATE=$(date "+%Y-%m-%d")
TIME=$(date "+%H:%M")
WORKSPACE="/workspace"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "🚀 会議開始"

mkdir -p "${WORKSPACE}/meetings"
cd "${WORKSPACE}"

# プロンプト構築
ROLE=$(cat "${WORKSPACE}/company/role.md")
AGENDA=$(cat "${WORKSPACE}/company/agenda.md")
PROMPT="${ROLE}

${AGENDA}"

# 会議実行
claude -p --dangerously-skip-permissions "$PROMPT" 2>&1 | tee "meetings/${TIMESTAMP}.md"

log "✅ 会議終了"

# プッシュ
if [ -d ".git" ]; then
    log "📤 プッシュ中..."

    [ -n "$GH_TOKEN" ] && git remote set-url origin "https://${GH_TOKEN}@github.com/onizuka-agi-co/onipod.git"

    git config user.email "onizuka.renjiii@gmail.com"
    git config user.name "onizukarenjiii-droid"
    git add -A
    git commit -m "🚀 会議 ${DATE} ${TIME}" || true
    git push origin main || log "⚠️ プッシュスキップ"
    log "✅ プッシュ完了"
fi
