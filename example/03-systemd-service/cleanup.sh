#!/bin/bash
# クリーンアップスクリプト

echo "systemd サービスを停止・無効化..."
systemctl --user stop container-systemd-nginx 2>/dev/null
systemctl --user disable container-systemd-nginx 2>/dev/null

echo "サービスファイルを削除..."
rm -f ~/.config/systemd/user/container-systemd-nginx.service
systemctl --user daemon-reload

echo "コンテナを削除..."
podman rm -f systemd-nginx 2>/dev/null

echo "完了!"
