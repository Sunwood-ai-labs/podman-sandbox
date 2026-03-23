# Podman Example

Podman の基本的な使い方を学ぶための例集です。

## ディレクトリ構成

```
example/
├── 01-basic-container/    # 基本的なコンテナ実行
├── 02-pod-example/        # Pod の使い方
├── 03-systemd-service/    # systemd 統合
├── 04-dockerfile-example/ # Dockerfile ビルド
├── 05-claudecode-example/ # ClaudeCode 内蔵コンテナ
├── 06-envfile-example/    # .env ファイル読み込み
└── 07-compose-example/    # podman-compose (docker-compose 互換)
```

## 各例の内容

| No | 例 | 内容 | 難易度 |
|----|-----|------|--------|
| 01 | basic-container | nginx を起動してアクセス | ★☆☆ |
| 02 | pod-example | 複数コンテナを Pod で管理 | ★★☆ |
| 03 | systemd-service | コンテナを systemd サービス化 | ★★☆ |
| 04 | dockerfile-example | Dockerfile からビルド | ★★☆ |
| 05 | claudecode-example | Claude Code CLI を内蔵したコンテナ | ★★★ |
| 06 | envfile-example | .env ファイルで環境変数管理 | ★★☆ |
| 07 | compose-example | docker-compose.yml で複数コンテナ管理 | ★★☆ |

## 実行方法

```bash
# 各ディレクトリに移動して実行
cd 01-basic-container
./run.sh
```

## 前提条件

- Podman がインストールされていること
- ネットワーク接続があること（イメージ取得用）

```bash
# Podman のインストール (Debian/Ubuntu)
sudo apt install -y podman

# podman-compose のインストール (07用)
sudo apt install -y podman-compose

# バージョン確認
podman --version
podman-compose --version
```

## 全体のクリーンアップ

すべての例を実行した後:

```bash
# コンテナ停止・削除
podman rm -af

# イメージ削除
podman rmi -af

# Pod 削除
podman pod rm -af

# ボリューム削除
podman volume rm -af
```

## 参考資料

- [Podman 公式ドキュメント](https://podman.io/)
- [Podman GitHub](https://github.com/containers/podman)
- [Podman Compose](https://github.com/containers/podman-compose)
- [Claude Code](https://github.com/anthropics/claude-code)
