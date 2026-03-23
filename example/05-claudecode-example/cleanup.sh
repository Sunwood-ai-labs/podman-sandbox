#!/bin/bash
# クリーンアップスクリプト

echo "イメージを削除..."
podman rmi -f claudecode 2>/dev/null

echo "完了!"
