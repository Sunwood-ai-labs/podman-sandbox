#!/bin/bash
# Podman 基本的なコンテナ実行例
# nginx コンテナを起動してアクセスする

set -e

echo "=== Podman 基本例 ==="

# イメージを取得
echo "1. nginx イメージを取得..."
podman pull docker.io/library/nginx:alpine

# コンテナを実行
echo "2. コンテナを起動..."
podman run -d --name my-nginx -p 8081:80 nginx:alpine

# コンテナ一覧を表示
echo "3. コンテナ一覧..."
podman ps

# 動作確認
echo "4. 動作確認 (curl でアクセス)..."
sleep 2
curl -s http://localhost:8081 | head -5

echo ""
echo "=== 完了 ==="
echo "停止: podman stop my-nginx"
echo "削除: podman rm my-nginx"
