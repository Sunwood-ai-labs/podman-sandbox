#!/bin/bash
set -e

echo "=== 🧹 Cleanup ==="
podman-compose down
podman rmi claude-meeting-bot:latest 2>/dev/null || true

echo ""
echo "議事録を削除しますか？ [y/N]"
read -r answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    rm -rf reports/* 2>/dev/null || true
    echo "議事録を削除しました"
fi

echo "Done!"
