#!/bin/bash
# CTO会議 - 技術的な実務会議
# company/ フォルダの情報を参照して実行

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

log "=== 💻 CTO会議開始 ==="

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
    "技術調査: Podmanの新機能やベストプラクティス"
    "ドキュメント改善: READMEやコメントの充実"
    "テスト計画: サンプルスクリプトの動作確認"
    "アイデア出し: 新しいサンプル例の提案"
    "リファクタリング: コードの整理と最適化"
    "セキュリティ確認: コンテナ設定の安全性"
    "パフォーマンス: ビルドや実行の効率化"
)

HOUR=$(date +"%H")
AGENDA="${AGENDAS[$((HOUR % ${#AGENDAS[@]}))]}"

log "📋 アジェンダ: $AGENDA"

# Claude に会議を依頼
OUTPUT=$(claude -p "あなたはCTO（最高技術責任者）です。

## 会社のミッション
${MISSION}

## 戦略
${STRATEGY}

## CTO会議ルール
${CTO_RULES}

## 現在のフォーカス
${FOCUS}

---

## 本日のアジェンダ
${AGENDA}

## タスク
上記の情報を踏まえて議事録を作成してください。
CTO会議ルールに記載された出力形式に従ってください。

日本語で簡潔に出力してください。" 2>&1) || OUTPUT="⚠️ 会議実行エラー"

# 議事録保存
cat > "$REPORT_FILE" <<EOF
# 💻 CTO会議 ${DATE} ${TIME}

**アジェンダ**: ${AGENDA}

---

${OUTPUT}

---

*CTO Meeting - Evolutionary Meeting Bot*
EOF

log "✅ CTO会議終了: ${REPORT_FILE}"
