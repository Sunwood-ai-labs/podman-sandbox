#!/bin/bash
# Podman Pod の例
# 複数コンテナをPod単位で管理

set -e

echo "=== Podman Pod 例 ==="

# Podを作成
echo "1. Pod を作成 (ポート 8082 を公開)..."
podman pod create --name my-pod -p 8082:80

# Podにコンテナを追加
echo "2. nginx コンテナを Pod に追加..."
podman run -d --pod my-pod --name web nginx:alpine

# Pod の状態を確認
echo "3. Pod の状態..."
podman pod ps

echo "4. Pod 内のコンテナ一覧..."
podman ps --pod

echo ""
echo "=== 完了 ==="
echo "Pod 停止: podman pod stop my-pod"
echo "Pod 削除: podman pod rm my-pod"
