#!/bin/bash
# CEO会議 - 戦略・改善会議
# CTO会議を評価して、自分でcompany/ファイルを修正する

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

# Claude に戦略分析と即時修正を依頼
OUTPUT=$(claude -p "あなたはCEO（最高経営責任者）です。
**重要**: 評価したら、自分でファイルを修正してください。

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

## あなたのタスク

### 1. CTO会議を評価
- スプリントゴール達成率
- インクリメント品質
- レトロスペクティブの質
- ブロッカーの有無

### 2. 必要なファイルを**今すぐ修正**
改善が必要なファイルがあれば、更新後の完全な内容を出力してください。
出力した内容は自動的にファイルに反映されます。

修正が必要なファイルごとに、以下の形式で出力：

\`\`\`file:cto-rules.md
（更新後のcto-rules.mdの完全な内容、変更がなければ出力しない）
\`\`\`

\`\`\`file:ceo-rules.md
（更新後のceo-rules.mdの完全な内容、変更がなければ出力しない）
\`\`\`

\`\`\`file:focus.md
（更新後のfocus.mdの完全な内容、変更がなければ出力しない）
\`\`\`

\`\`\`file:strategy.md
（更新後のstrategy.mdの完全な内容、変更がなければ出力しない）
\`\`\`

\`\`\`file:history.md
（追記する内容のみ）
\`\`\`

### 3. 議事録の出力形式

\`\`\`markdown
## 📊 CTO会議評価

### スプリントゴール達成率
- 達成率: XX%

### 評価サマリー
- 良かった点: ...
- 改善が必要な点: ...

## 🔧 実施した修正
（修正したファイルと内容の要約）

## 📈 次回への引き継ぎ
- 次回のCTO会議に期待すること
\`\`\`

日本語で出力してください。" 2>&1) || OUTPUT="⚠️ 分析エラー"

# ファイル更新を抽出して適用
extract_and_save() {
    local filename="$1"
    local pattern="file:${filename}"
    local content=$(echo "$OUTPUT" | sed -n "/\`\`\`${pattern}/,/\`\`\`/p" | sed '1d;$d')

    if [ -n "$content" ]; then
        echo "$content" > "${COMPANY_DIR}/${filename}"
        log "📝 ${filename} を更新"
    fi
}

# 各ファイルを更新
extract_and_save "cto-rules.md"
extract_and_save "ceo-rules.md"
extract_and_save "focus.md"
extract_and_save "strategy.md"

# history.md は追記
HISTORY_ADD=$(echo "$OUTPUT" | sed -n '/```file:history.md/,/```/p' | sed '1d;$d')
if [ -n "$HISTORY_ADD" ]; then
    echo "" >> "${COMPANY_DIR}/history.md"
    echo "### ${DATE} ${TIME}" >> "${COMPANY_DIR}/history.md"
    echo "$HISTORY_ADD" >> "${COMPANY_DIR}/history.md"
    log "📝 history.md に追記"
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
