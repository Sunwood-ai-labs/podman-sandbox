# systemd統合

Podmanはsystemdとのネイティブ統合を提供し、コンテナをシステムサービスとして管理できます。

## 概要

PodmanはコンテナとPodのsystemdサービスファイルを生成でき、以下のことが可能になります：
- ブート時の自動起動
- 標準的なsystemctlコマンドでの管理
- システムログ（journalctl）との統合

## 基本的な使い方

### サービスファイルの生成

```bash
# コンテナ用
podman generate systemd --name my-container

# --newフラグで起動時に再作成
podman generate systemd --new --name my-container

# Pod用
podman generate systemd --pod --name my-pod
```

### サービスの場所

```bash
# ユーザーサービス（rootless）
~/.config/systemd/user/

# システムサービス（root）
/etc/systemd/system/
```

## 完全な例

### 1. コンテナの作成

```bash
podman run -d --name webapp -p 8080:80 nginx:alpine
```

### 2. サービスファイルの生成

```bash
mkdir -p ~/.config/systemd/user
podman generate systemd --new --name webapp > ~/.config/systemd/user/container-webapp.service
```

### 3. 有効化と起動

```bash
systemctl --user daemon-reload
systemctl --user enable --now container-webapp
```

### 4. 確認

```bash
systemctl --user status container-webapp
```

## サービス管理コマンド

```bash
# サービス起動
systemctl --user start container-webapp

# サービス停止
systemctl --user stop container-webapp

# サービス再起動
systemctl --user restart container-webapp

# ログ表示
journalctl --user -u container-webapp

# ブート時有効化
systemctl --user enable container-webapp

# ブート時無効化
systemctl --user disable container-webapp
```

## 利点

| 機能 | Docker | Podman |
|------|--------|--------|
| ブート時自動起動 | --restartフラグ | ネイティブsystemd |
| サービス生成 | 手動 | 自動 |
| ログ統合 | 別々 | journalctl |
| 依存関係管理 | 制限あり | systemd完全対応 |

## ベストプラクティス

1. **`--new`フラグの使用**: 各起動時にクリーンなコンテナ状態を保証
2. **rootlessにはユーザーサービス**: 非rootユーザーとしてコンテナを実行
3. **Podサービス**: 関連するコンテナをグループ化
4. **lingerの有効化**: クリーンなシャットダウンのために`--stop-timeout`を使用
5. **ログ監視**: 集中ログのためにjournalctlを使用
