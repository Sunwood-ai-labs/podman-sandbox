#!/bin/bash
# CTO会議 - アジャイル方式の技術実務会議

set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M")
DATE=$(date "+%Y-%m-%d")
TIME=$(date "+%H:%M")
WORKSPACE="/workspace"
COMPANY_DIR="${WORKSPACE}/company"
CTO_DIR="${WORKSPACE}/meetings/cto"
REPORT_FILE="${CTO_DIR}/${TIMESTAMP}.md"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "=== 💻 CTO会議開始 (アジャイル) ==="

mkdir -p "${CTO_DIR}"

# カンパニー情報を読み込む
MISSION=$(cat "${COMPANY_DIR}/mission.md" 2>/dev/null || echo "ミッション未設定")
STRATEGY=$(cat "${COMPANY_DIR}/strategy.md" 2>/dev/null || echo "戦略未設定")
CTO_RULES=$(cat "${COMPANY_DIR}/cto-rules.md" 2>/dev/null || echo "ルール未設定")
FOCUS=$(cat "${COMPANY_DIR}/focus.md" 2>/dev/null || echo "フォーカス未設定")

log "📋 カンパニー情報を読み込み"

# アジェンダ
AGENDAS=(
    "コードレビュー: サンプルコードの品質確認と改善点"
    "技術調査: 新機能やベストプラクティス"
    "ドキュメント改善: READMEやコメントの充実"
    "テスト計画: スクリプトの動作確認"
    "アイデア出し: 新しい機能の提案"
    "リファクタリング: コードの整理と最適化"
    "セキュリティ確認: 設定の安全性"
    "パフォーマンス: ビルドや実行の効率化"
)

HOUR=$(date +"%H")
AGENDA="${AGENDAS[$((HOUR % ${#AGENDAS[@]}))]}"

log "🎯 スプリントテーマ: $AGENDA"

# Claude に会議を依頼
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

## タスク
アジャイル方式で以下の構成の議事録を作成してください：

### 🎯 スプリントゴール
### 📋 スプリントバックログ
### ✅ 完了したタスク
### 📦 インクリメント (成果物)
### 🔍 レトロスペクティブ (Keep/Problem/Try)
### 🚫 ブロッカー

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

# 成果物をリポジトリにプッシュ
if [ -d "${WORKSPACE}/.git" ] && [ -n "$GH_TOKEN" ]; then
    log "📤 成果物をプッシュ中..."
    cd "${WORKSPACE}"
    git config user.email "onizuka.renjiii@gmail.com"
    git config user.name "onizukarenjiii-droid"
    git add company/ 2>/dev/null || true
    git commit -m "📄 CTO会議 ${DATE} ${TIME}: ${AGENDA}" || true
    git push origin main || log "⚠️ プッシュスキップ"
fi
