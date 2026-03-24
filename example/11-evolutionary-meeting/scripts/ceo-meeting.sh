#!/bin/bash
# CEO会議 - 戦略・改善会議
# CTO会議を評価して company/ ファイルを更新

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M")
DATE=$(date "+%Y-%m-%d"
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

mkdir -p "${CEO_DIR}"
mkdir -p "${COMPANY_DIR}"

# 直近のCTO会議を取得
RECENT_CTO=$(ls -t "${CTO_DIR}"/*.md 2>/dev/null | head -3 || echo "")

if [ -z "$RECENT_CTO" ]; then
    log "📭 CTO会議履歴なし。初期設定のみ"

    cat > "$REPORT_FILE" <<EOF
# 👔 CEO会議 ${DATE} ${TIME}

**決定事項**: 初期運用開始

---

## 状況

CTO会議がまだ実施されていません。
次回のCTO会議を待ちます。

---

*CEO Meeting - Evolutionary Meeting Bot*
EOF
    log "✅ CEO会議終了"
    exit 0
fi

# CTO会議内容を結合
CTO_CONTENT=""
for f in $RECENT_CTO; do
    CTO_CONTENT="${CTO_CONTENT}$(cat "$f")\n\n---\n\n"
done

# 現在のカンパニー情報を読み込む
MISSION=$(cat "${COMPANY_DIR}/mission.md" 2>/dev/null || echo "")
STRATEGY=$(cat "${COMPANY_DIR}/strategy.md" 2>/dev/null || echo "")
CEO_RULES=$(cat "${COMPANY_DIR}/ceo-rules.md" 2>/dev/null || echo "")
CTO_RULES=$(cat "${COMPANY_DIR}/cto-rules.md" 2>/dev/null || echo "")
FOCUS=$(cat "${COMPANY_DIR}/focus.md" 2>/dev/null || echo "")

log "📊 直近のCTO会議を分析中..."

# Claude に戦略分析を依頼
OUTPUT=$(claude -p "あなたはCEO（最高経営責任者）です。

## 現在の会社情報

### ミッション
${MISSION}

### 戦略
${STRATEGY}

### CEO会議ルール
${CEO_RULES}

### 現在のCTO会議ルール
${CTO_RULES}

### 現在のフォーカス
${FOCUS}

---

## 直近のCTO会議議事録
${CTO_CONTENT}

---

## タスク

CTO会議の成果を評価し、必要に応じてファイルを更新してください。
CEO会議ルールに記載された出力形式に従ってください。

### 評価基準
- 効率性: CTO会議は時間内に終了したか？
- 具体性: アクションアイテムは実行可能か？
- 整合性: フォーカスと合致しているか？
- 品質: 議事録の質はどうか？

### 出力形式

\`\`\`markdown
## 📊 CTO会議評価
- 評価内容

## 📋 更新が必要なファイル

### cto-rules.md
（更新後の内容、変更がなければ「変更なし」）

### ceo-rules.md
（更新後の内容、変更がなければ「変更なし」）

### focus.md
（更新後の内容、変更がなければ「変更なし」）

### strategy.md
（更新後の内容、変更がなければ「変更なし」）

## 📝 history.md 追記用
（追記すべき内容があれば）
\`\`\`

日本語で出力してください。" 2>&1) || OUTPUT="⚠️ 分析エラー"

# ファイル更新を抽出して適用
if echo "$OUTPUT" | grep -q "cto-rules.md"; then
    NEW_RULES=$(echo "$OUTPUT" | sed -n '/### cto-rules.md/,/### /p' | sed '1d;$d' | sed '/^$/d' | head -50)
    if [ -n "$NEW_RULES" ] && [ "$NEW_RULES" != "変更なし" ]; then
        echo "$NEW_RULES" > "${COMPANY_DIR}/cto-rules.md"
        log "📝 cto-rules.md を更新"
    fi
fi

if echo "$OUTPUT" | grep -q "ceo-rules.md"; then
    NEW_CEO_RULES=$(echo "$OUTPUT" | sed -n '/### ceo-rules.md/,/### /p' | sed '1d;$d' | sed '/^$/d' | head -50)
    if [ -n "$NEW_CEO_RULES" ] && [ "$NEW_CEO_RULES" != "変更なし" ]; then
        echo "$NEW_CEO_RULES" > "${COMPANY_DIR}/ceo-rules.md"
        log "📝 ceo-rules.md を更新"
    fi
fi

if echo "$OUTPUT" | grep -q "focus.md"; then
    NEW_FOCUS=$(echo "$OUTPUT" | sed -n '/### focus.md/,/### /p' | sed '1d;$d' | sed '/^$/d' | head -30)
    if [ -n "$NEW_FOCUS" ] && [ "$NEW_FOCUS" != "変更なし" ]; then
        echo "$NEW_FOCUS" > "${COMPANY_DIR}/focus.md"
        log "📝 focus.md を更新"
    fi
fi

if echo "$OUTPUT" | grep -q "strategy.md"; then
    NEW_STRATEGY=$(echo "$OUTPUT" | sed -n '/### strategy.md/,/## /p' | sed '1d;$d' | sed '/^$/d' | head -50)
    if [ -n "$NEW_STRATEGY" ] && [ "$NEW_STRATEGY" != "変更なし" ]; then
        echo "$NEW_STRATEGY" > "${COMPANY_DIR}/strategy.md"
        log "📝 strategy.md を更新"
    fi
fi

if echo "$OUTPUT" | grep -q "history.md"; then
    HISTORY_ADD=$(echo "$OUTPUT" | sed -n '/## 📝 history.md 追記用/,/```/p' | sed '1d;$d' | sed '/^$/d')
    if [ -n "$HISTORY_ADD" ]; then
        echo "" >> "${COMPANY_DIR}/history.md"
        echo "### ${DATE}" >> "${COMPANY_DIR}/history.md"
        echo "$HISTORY_ADD" >> "${COMPANY_DIR}/history.md"
        log "📝 history.md に追記"
    fi
fi

# 議事録保存
cat > "$REPORT_FILE" <<EOF
# 👔 CEO会議 ${DATE} ${TIME}

---

${OUTPUT}

---

*CEO Meeting - Evolutionary Meeting Bot*
EOF

log "✅ CEO会議終了"
