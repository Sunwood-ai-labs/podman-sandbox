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

# Claude に会議と成果物生成を依頼
OUTPUT=$(claude -p "あなたはCTO（最高技術責任者）です。アジャイル方式でスプリントを実行してください。

## 会社のミッション
${MISSION}

## 戦略
${STRATEGY}

## CTO会議ルール (アジャイル)
${CTO_RULES}

## 現在のフォーカス
${FOCUS}

---

## 今回のスプリントテーマ
${AGENDA}

## 重要: 成果物を生成してください

会議の議論だけでなく、**実際の成果物**を生成してください。
成果物は \`/workspace/deliverables/\` ディレクトリに出力してください。

### 成果物の例
- ドキュメント: README.md, GUIDE.md など
- コード: スクリプト、設定ファイル
- 設計書: 設計ドキュメント、図解
- 調査レポート: 調査結果のまとめ

### 出力形式

議事録:
\`\`\`markdown
### 🎯 スプリントゴール
### 📋 スプリントバックログ
### ✅ 完了したタスク
### 📦 成果物リスト
- /workspace/deliverables/xxx.md
- /workspace/deliverables/xxx.sh
### 🔍 レトロスペクティブ
### 🚫 ブロッカー
\`\`\`

成果物ファイル:
\`\`\`file:/workspace/deliverables/xxx.md
（ファイル内容）
\`\`\`

まず議事録を出力し、その後に成果物ファイルを出力してください。
日本語で出力してください。" 2>&1) || OUTPUT="⚠️ 会議実行エラー"

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

# 成果物ファイルを抽出して保存
extract_files=$(echo "$OUTPUT" | grep -oE '\`\`\`file:/workspace/deliverables/[^`]+\`\`\`' | sort -u)
for file_match in $extract_files; do
    filepath=$(echo "$file_match" | sed 's/\`\`\`file://;s/\`\`\`//')
    filename=$(basename "$filepath")
    content=$(echo "$OUTPUT" | sed -n "/\`\`\`file:${filepath}/,/\`\`\`/p" | sed '1d;$d')
    if [ -n "$content" ]; then
        echo "$content" > "${DELIVERABLES_DIR}/${filename}"
        log "📦 成果物保存: ${filename}"
    fi
done

# 成果物をリポジトリにプッシュ
if [ -d "${WORKSPACE}/.git" ] && [ -n "$GH_TOKEN" ]; then
    log "📤 成果物をプッシュ中..."
    cd "${WORKSPACE}"
    git config user.email "onizuka.renjiii@gmail.com"
    git config user.name "onizukarenjiii-droid"
    git add company/ meetings/ deliverables/ 2>/dev/null || true
    git commit -m "📄 CTO会議 ${DATE} ${TIME}: ${AGENDA}

- 議事録: meetings/cto/${TIMESTAMP}.md
- 成果物: deliverables/

Co-Authored-By: Evolutionary Meeting Bot <noreply@evolution.bot>" || true
    git push origin main || log "⚠️ プッシュスキップ"
fi
