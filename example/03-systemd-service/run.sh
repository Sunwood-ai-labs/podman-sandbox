#!/bin/bash
# Podman systemd 統合の例
# コンテナを systemd サービスとして管理

set -e

echo "=== Podman systemd 統合例 ==="

# コンテナを作成（まだ起動しない）
echo "1. コンテナを作成..."
podman create --name systemd-nginx -p 8081:80 nginx:alpine

# systemd サービスファイルを生成
echo "2. systemd サービスファイルを生成..."
mkdir -p ~/.config/systemd/user/
podman generate systemd --name systemd-nginx --new > ~/.config/systemd/user/container-systemd-nginx.service

# サービスを有効化
echo "3. systemd で有効化..."
systemctl --user daemon-reload
systemctl --user enable --now container-systemd-nginx

# ステータス確認
echo "4. ステータス確認..."
systemctl --user status container-systemd-nginx --no-pager

echo ""
echo "=== 完了 ==="
echo "サービス停止: systemctl --user stop container-systemd-nginx"
echo "サービス無効化: systemctl --user disable container-systemd-nginx"
