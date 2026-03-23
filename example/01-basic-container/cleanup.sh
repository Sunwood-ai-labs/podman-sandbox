#!/bin/bash
# クリーンアップスクリプト

echo "コンテナを停止・削除..."
podman stop my-nginx 2>/dev/null
podman rm my-nginx 2>/dev/null

echo "完了!"
