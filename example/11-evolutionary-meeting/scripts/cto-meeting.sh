#!/bin/bash
# CTO会議 - アジャイル方式の技術実務会議
# Claude CLIに成果物生成を委ね

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

# アジェンダ（時間ベースローテーション）
HOUR=$(date +"%H")
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

AGENDA="${AGENDAS[$((HOUR % ${#AGENDAS[@]}))]}"

log "🎯 スプリントテーマ: $AGENDA"

# Claude CLI に会議と成果物生成を依頼（デンジャラスモード）
log "🤖 Claude CLI に会議依頼中..."

OUTPUT=$(claude -p --dangerously-skip-permissions "あなたはCTO（最高技術責任任者）です。アジャイル方式でスプリントを実行してください。

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

1. スプリントゴールを設定
2. アクションアイテムをリストアップ
3. **成果物を生成する**

成果物は deliverables/ ディレクトリに出力してください。

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
