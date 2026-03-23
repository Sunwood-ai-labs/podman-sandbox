#!/bin/bash
# クリーンアップスクリプト

echo "イメージを削除..."
podman rmi -f my-curl-app 2>/dev/null

echo "完了!"
