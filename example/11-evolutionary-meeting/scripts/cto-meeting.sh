#!/bin/bash
# CTO会議 - アジャイル方式の技術実務会議
# 実際の成果物を生成してコミット

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M")
DATE=$(date "+%Y-%m-%d")
TIME=$(date "+%H:%M")
WORKSPACE="/workspace"
COMPANY_DIR="${WORKSPACE}/company"
CTO_DIR="${WORKSPACE}/meetings/cto"
DELIVERABLES_DIR="${WORKSPACE}/deliverables"
REPORT_FILE="${CTO_DIR}/${TIMESTAMP}.md"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "=== 💻 CTO会議開始 (アジャイル) ==="

mkdir -p "${CTO_DIR}" "${DELIVERABLES_DIR}"

# カンパニー情報を読み込む
MISSION=$(cat "${COMPANY_DIR}/mission.md" 2>/dev/null || echo "ミッション未設定")
STRATEGY=$(cat "${COMPANY_DIR}/strategy.md" 2>/dev/null || echo "戦略未設定")
CTO_RULES=$(cat "${COMPANY_DIR}/cto-rules.md" 2>/dev/null || echo "ルール未設定")
FOCUS=$(cat "${COMPANY_DIR}/focus.md" 2>/dev/null || echo "フォーカス未設定")

log "📋 カンパニー情報を読み込み"

# アジェンダ
AGENDAS=(
    "コードレビュー: コードの品質確認と改善"
    "技術調査: 新機能やベストプラクティス調査"
    "ドキュメント改善: READMEやコメントの充実"
    "テスト作成: テストコードの作成"
    "新機能実装: 新しい機能の実装"
    "リファクタリング: コードの整理と最適化"
    "セキュリティ確認: 設定の安全性確認"
    "パフォーマンス: ビルドや実行の効率化"
)

HOUR=$(date +"%H")
AGENDA="${AGENDAS[$((HOUR % ${#AGENDAS[@]}))]}"

log "🎯 スプリントテーマ: $AGENDA"

# プロンプトをファイルに保存して実行
PROMPT_FILE="/tmp/cto_prompt_${TIMESTAMP}.txt"
cat > "$PROMPT_FILE" << 'PROMPT_EOF'
あなたはCTO（最高技術責任者）です。アジャイル方式でスプリントを実行してください。

## 会社のミッション
PROMPT_EOF

echo "${MISSION}" >> "$PROMPT_FILE"

cat >> "$PROMPT_FILE" << 'PROMPT_EOF'

## 戦略
PROMPT_EOF

echo "${STRATEGY}" >> "$PROMPT_FILE"

cat >> "$PROMPT_FILE" << 'PROMPT_EOF'

## CTO会議ルール (アジャイル)
PROMPT_EOF

echo "${CTO_RULES}" >> "$PROMPT_FILE"

cat >> "$PROMPT_FILE" << 'PROMPT_EOF'

## 現在のフォーカス
PROMPT_EOF

echo "${FOCUS}" >> "$PROMPT_FILE"

cat >> "$PROMPT_FILE" << 'PROMPT_EOF'

---

## 今回のスプリントテーマ
PROMPT_EOF

echo "${AGENDA}" >> "$PROMPT_FILE"

cat >> "$PROMPT_FILE" << 'PROMPT_EOF'

---

## 🚨 最重要: 成果物ファイルを必ず生成してください

会議の議論だけでなく、**実際の成果物ファイルの中身**を生成してください。
以下の形式を厳守してください：

### 成果物ファイル出力形式（必須）

各ファイルを以下の形式で出力：

===FILE_START:deliverables/ファイル名===
（ここにファイルの中身を書く）
===FILE_END===

### 例

===FILE_START:deliverables/README.md===
# サンプルREADME

これはサンプルです。
===FILE_END===

===FILE_START:deliverables/guide.sh===
#!/bin/bash
echo "Hello"
===FILE_END===

### 成果物の種類（テーマに合わせて選択）
- ドキュメント: guide.md, README.md, design.md
- スクリプト: script.sh, setup.sh
- 設定ファイル: config.yaml, settings.json

## 出力構成

1. スプリントゴール
2. バックログ
3. 完了タスク
4. 成果物ファイル（===FILE_START:deliverables/xxx=== 形式で必ず出力）
5. レトロスペクティブ
6. ブロッカー

**必ず1つ以上の成果物ファイルを出力してください！**

日本語で出力してください。
PROMPT_EOF

# Claude に会議と成果物生成を依頼
OUTPUT=$(claude -p "$(cat "$PROMPT_FILE")" 2>&1) || OUTPUT="⚠️ 会議実行エラー"

# 一時ファイル削除
rm -f "$PROMPT_FILE"

# 議事録保存
cat > "$REPORT_FILE" <<EOF
# 💻 CTO会議 ${DATE} ${TIME}

**スプリントテーマ**: ${AGENDA}

---

${OUTPUT}

---

*CTO Meeting (Agile) - Evolutionary Meeting Bot*
EOF

log "✅ CTO会議終了: ${REPORT_FILE}"

# 成果物ファイルを抽出して保存（BusyBox対応）
log "📦 成果物を抽出中..."

current_file=""
current_content=""
in_file=0

while IFS= read -r line; do
    if echo "$line" | grep -q "^===FILE_START:deliverables/"; then
        # deliverables/xxx を抽出（===を除去）
        current_file="deliverables/$(echo "$line" | sed 's/^===FILE_START:deliverables\///;s/===$//')"
        in_file=1
        current_content=""
    elif echo "$line" | grep -q "^===FILE_END==="; then
        if [ -n "$current_file" ] && [ -n "$current_content" ]; then
            echo "$current_content" > "${WORKSPACE}/${current_file}"
            log "📦 成果物保存: ${current_file}"
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

# 成果物数確認
DELIVERABLES_COUNT=$(ls -1 "${DELIVERABLES_DIR}" 2>/dev/null | grep -v ".gitkeep" | wc -l)
log "📦 成果物数: ${DELIVERABLES_COUNT}"

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
        git commit -m "📄 CTO会議 ${DATE} ${TIME}: ${AGENDA}

- 議事録: meetings/cto/${TIMESTAMP}.md
- 成果物: deliverables/ (${DELIVERABLES_COUNT}件)

Co-Authored-By: Evolutionary Meeting Bot <noreply@evolution.bot>" || true
        git push origin main || log "⚠️ プッシュスキップ"
        log "✅ プッシュ完了"
    else
        log "📝 コミットする変更なし"
    fi
fi
