#!/bin/bash
# クリーンアップスクリプト

echo "Pod を停止・削除..."
podman pod stop my-pod 2>/dev/null
podman pod rm my-pod 2>/dev/null

echo "完了!"
