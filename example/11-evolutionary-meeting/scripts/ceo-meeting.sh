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
DELIVERABLES_DIR="${WORKSPACE}/deliverables"
REPORT_FILE="${CEO_DIR}/${TIMESTAMP}.md"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "=== 👔 CEO会議開始 ==="

mkdir -p "${CEO_DIR}" "${COMPANY_DIR}" "${DELIVERABLES_DIR}"

# 直近のCTO会議を取得
RECENT_CTO=$(ls -t "${CTO_DIR}"/*.md 2>/dev/null | head -3 || echo "")

if [ -z "$RECENT_CTO" ]; then
    log "📭 CTO会議履歴なし"
    cat > "$REPORT_FILE" <<EOF
# 👔 CEO会議 ${DATE} ${TIME}

**決定事項**: CTO会議待機中

---

CTO会議がまだ実施されていません。

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

# カンパニー情報を読み込む
MISSION=$(cat "${COMPANY_DIR}/mission.md" 2>/dev/null || echo "")
STRATEGY=$(cat "${COMPANY_DIR}/strategy.md" 2>/dev/null || echo "")
CEO_RULES=$(cat "${COMPANY_DIR}/ceo-rules.md" 2>/dev/null || echo "")
CTO_RULES=$(cat "${COMPANY_DIR}/cto-rules.md" 2>/dev/null || echo "")
FOCUS=$(cat "${COMPANY_DIR}/focus.md" 2>/dev/null || echo "")

log "📊 CTO会議を分析中..."

# Claude に分析と修正を依頼
OUTPUT=$(claude -p "あなたはCEO（最高経営責任者）です。CTO会議を評価し、会社情報を更新してください。

## 会社情報
ミッション: ${MISSION}
戦略: ${STRATEGY}
CEOルール: ${CEO_RULES}
CTOルール: ${CTO_RULES}
フォーカス: ${FOCUS}

## CTO会議議事録（直近3件）
${CTO_CONTENT}

---

## タスク

### 1. CTO会議を評価
- スプリントゴール達成率（%）
- 成果物の品質評価
- レトロスペクティブの質

### 2. 会社情報ファイルを更新（必要な場合のみ）

更新が必要な場合のみ、以下の形式で出力：

\`\`\`
===FILE_START:company/cto-rules.md===
（更新後の内容全体）
===FILE_END===
\`\`\`

\`\`\`
===FILE_START:company/focus.md===
（更新後の内容全体）
===FILE_END===
\`\`\`

\`\`\`
===FILE_START:company/strategy.md===
（更新後の内容全体）
===FILE_END===
\`\`\`

\`\`\`
===FILE_START:company/history.md===
（追記する内容のみ）
===FILE_END===
\`\`\`

日本語で出力してください。" 2>&1) || OUTPUT="⚠️ 分析エラー"

# 議事録保存
cat > "$REPORT_FILE" <<EOF
# 👔 CEO会議 ${DATE} ${TIME}

${OUTPUT}

---

*CEO Meeting - Evolutionary Meeting Bot*
EOF

log "✅ CEO会議終了"

# ファイル更新を適用（BusyBox対応）
current_file=""
current_content=""
in_file=0

while IFS= read -r line; do
    if echo "$line" | grep -q "^===FILE_START:company/"; then
        current_file=$(echo "$line" | sed 's/^===FILE_START://' | sed 's|company/||')
        in_file=1
        current_content=""
    elif echo "$line" | grep -q "^===FILE_END==="; then
        if [ -n "$current_file" ] && [ -n "$current_content" ]; then
            if [ "$current_file" = "history.md" ]; then
                # history.md は追記
                echo -e "\n### ${DATE} ${TIME}\n${current_content}" >> "${COMPANY_DIR}/${current_file}"
                log "📝 ${current_file} に追記"
            else
                # その他は上書き
                echo "$current_content" > "${COMPANY_DIR}/${current_file}"
                log "📝 ${current_file} を更新"
            fi
        fi
        in_file=0
        current_file=""
        current_content=""
    elif [ "$in_file" -eq 1 ]; then
        if [ -n "$current_content" ]; then
            current_content="${current_content}
${line}"
        else
            current_content="${line}"
        fi
    fi
done <<< "$OUTPUT"

# 成果物をリポジトリにプッシュ
if [ -d "${WORKSPACE}/.git" ]; then
    log "📤 成果物をプッシュ中..."
    cd "${WORKSPACE}"

    # 認証設定
    if [ -n "$GH_TOKEN" ]; then
        git remote set-url origin "https://${GH_TOKEN}@github.com/onizuka-agi-co/onipod.git"
    fi

    git config user.email "onizuka.renjiii@gmail.com"
    git config user.name "onizukarenjiii-droid"
    git add company/ meetings/ deliverables/ 2>/dev/null || true

    if [ -n "$(git status --porcelain)" ]; then
        git commit -m "👔 CEO会議 ${DATE} ${TIME}: ルール・フォーカス更新

- 議事録: meetings/ceo/${TIMESTAMP}.md
- 会社情報更新: company/

Co-Authored-By: Evolutionary Meeting Bot <noreply@evolution.bot>" || true
        git push origin main || log "⚠️ プッシュスキップ"
        log "✅ プッシュ完了"
    else
        log "📝 コミットする変更なし"
    fi
fi
