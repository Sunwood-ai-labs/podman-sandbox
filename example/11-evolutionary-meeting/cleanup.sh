#!/bin/bash
# Evolutionary Meeting Bot - 停止・クリーンアップ

set -e

echo "🛑 Evolutionary Meeting Bot 停止中..."

podman stop claude-evolution 2>/dev/null || true
podman rm claude-evolution 2>/dev/null || true

echo "✅ 停止完了"
echo ""
echo "💾 議事録や進化状態は workspace/ に残っています"
echo "🗑️  完全に削除する場合: rm -rf workspace/"
