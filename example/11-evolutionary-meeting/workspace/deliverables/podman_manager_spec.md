# Podman管理スクリプト

## 概要
このスクリプトは、Podmanコンテナの監視と基本的な管理機能を提供します。

## 機能
1. コンテナの一覧表示
2. コンテナの状態監視
3. コンテナの起動・停止・再起動
4. コンテナの削除
5. ログ出力機能

## 使用方法
./podman_manager.sh [オプション]

例:
./podman_manager.sh --list          # コンテナ一覧表示
./podman_manager.sh --start [ID]    # コンテナ起動
./podman_manager.sh --stop [ID]     # コンテナ停止