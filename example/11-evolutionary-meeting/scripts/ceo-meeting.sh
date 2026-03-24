#!/bin/bash
# CEO会議 - 戦略・改善会議

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M")
DATE=$(date "+%Y-%m-%d")
TIME=$(date "+%H:%M")
WORKSPACE="/workspace"
COMPANY_DIR="${WORKSPACE}/company"
CTO_DIR="${WORKSPACE}/meetings/cto"
CEO_DIR="${WORKSPACE}/meetings/ceo"
REPORT_FILE="${CEO_DIR}/${TIMESTAMP}.md"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "=== 👔 CEO会議開始 ==="

mkdir -p "${CEO_DIR}" "${COMPANY_DIR}"

# 直近のCTO会議を取得
RECENT_CTO=$(ls -t "${CTO_DIR}"/*.md 2>/dev/null | head -3 || echo "")

if [ -z "$RECENT_CTO" ]; then
    log "📭 CTO会議履歴なし"
    echo "CTO会議待機中" > "$REPORT_FILE"
    log "✅ CEO会議終了"
    exit 0
fi

# CTO会議内容を結合
CTO_CONTENT=""
for f in $RECENT_CTO; do
    CTO_CONTENT="${CTO_CONTENT}$(cat "$f")\n\n---\n\n"
done

# カンパニー情報を読み込む
MISSION=$(cat "${COMPANY_DIR}/mission.md" 2>/dev/null || echo "")
STRATEGY=$(cat "${COMPANY_DIR}/strategy.md" 2>/dev/null || echo "")
CEO_RULES=$(cat "${COMPANY_DIR}/ceo-rules.md" 2>/dev/null || echo "")
CTO_RULES=$(cat "${COMPANY_DIR}/cto-rules.md" 2>/dev/null || echo "")
FOCUS=$(cat "${COMPANY_DIR}/focus.md" 2>/dev/null || echo "")

log "📊 CTO会議を分析中..."

# Claude に分析と修正を依頼
OUTPUT=$(claude -p "あなたはCEOです。CTO会議を評価し、必要なファイルを修正してください。

## 会社情報
ミッション: ${MISSION}
戦略: ${STRATEGY}
CEOルール: ${CEO_RULES}
CTOルール: ${CTO_RULES}
フォーカス: ${FOCUS}

## CTO会議議事録
${CTO_CONTENT}

---

## タスク
1. CTO会議を評価
2. 必要なファイルを修正（以下の形式で出力）

\`\`\`file:cto-rules.md
（更新内容）
\`\`\`

\`\`\`file:focus.md
（更新内容）
\`\`\`

\`\`\`file:history.md
（追記内容）
\`\`\`

日本語で出力してください。" 2>&1) || OUTPUT="⚠️ 分析エラー"

# ファイル更新を適用
for file in cto-rules.md ceo-rules.md focus.md strategy.md; do
    content=$(echo "$OUTPUT" | sed -n "/\`\`\`file:${file}/,/\`\`\`/p" | sed '1d;$d')
    if [ -n "$content" ]; then
        echo "$content" > "${COMPANY_DIR}/${file}"
        log "📝 ${file} を更新"
    fi
done

# history.md は追記
HISTORY_ADD=$(echo "$OUTPUT" | sed -n '/```file:history.md/,/```/p' | sed '1d;$d')
if [ -n "$HISTORY_ADD" ]; then
    echo -e "\n### ${DATE} ${TIME}\n${HISTORY_ADD}" >> "${COMPANY_DIR}/history.md"
    log "📝 history.md に追記"
fi

# 議事録保存
cat > "$REPORT_FILE" <<EOF
# 👔 CEO会議 ${DATE} ${TIME}

${OUTPUT}

---

*CEO Meeting - Evolutionary Meeting Bot*
EOF

log "✅ CEO会議終了"

# 成果物をリポジトリにプッシュ
if [ -d "${WORKSPACE}/.git" ] && [ -n "$GH_TOKEN" ]; then
    log "📤 成果物をプッシュ中..."
    cd "${WORKSPACE}"
    git config user.email "onizuka.renjiii@gmail.com"
    git config user.name "onizukarenjiii-droid"
    git add company/ 2>/dev/null || true
    git commit -m "👔 CEO会議 ${DATE} ${TIME}: ルール・フォーカス更新" || true
    git push origin main || log "⚠️ プッシュスキップ"
fi
