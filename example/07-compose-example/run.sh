#!/bin/bash
# podman-compose 実行例

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "=== Podman Compose 例 ==="

# podman-compose の確認
if ! command -v podman-compose &> /dev/null; then
    echo "エラー: podman-compose がインストールされていません"
    echo ""
    echo "インストール方法:"
    echo "  sudo apt install -y podman-compose"
    echo "  または"
    echo "  pip install podman-compose"
    exit 1
fi

cd "$SCRIPT_DIR"

# 起動
echo "1. サービスを起動 (バックグラウンド)..."
podman-compose up -d

# ステータス確認
echo ""
echo "2. ステータス確認..."
podman-compose ps

# 動作確認
echo ""
echo "3. Web サーバー確認..."
sleep 3
curl -s http://localhost:8080 | head -5

echo ""
echo "4. ログ確認..."
podman-compose logs --tail=5

echo ""
echo "=== 完了 ==="
echo ""
echo "操作コマンド:"
echo "  ログ:     podman-compose logs -f"
echo "  停止:     podman-compose down"
echo "  再起動:   podman-compose restart"
echo ""
echo "クリーンアップ:"
echo "  ./cleanup.sh"
