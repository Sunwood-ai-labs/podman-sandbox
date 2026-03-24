# 始めよう

このガイドではPodmanのセットアップから最初のコンテナ実行までを説明します。

## 前提条件

- Linux、macOS、または Windows
- Podmanがインストールされていること

## インストール

### Linux (Fedora, RHEL, CentOS)

```bash
sudo dnf install podman
```

### macOS

```bash
brew install podman
```

### Windows

[Podman GitHub releases](https://github.com/containers/podman/releases) からダウンロード

## インストール確認

```bash
podman --version
```

## 最初のコンテナを実行

```bash
podman run -d --name hello-world -p 8080:80 docker.io/library/nginx:alpine
```

## 確認

```bash
podman ps
```

コンテナが実行されていることを確認できます。

## コンテナにアクセス

ブラウザで `http://localhost:8080` を開きます。

## クリーンアップ

```bash
podman rm -f hello-world
```

## 次のステップ

- [アーキテクチャ比較](/ja/guide/architecture) - PodmanとDockerの違いを理解する
- [サンプル](/ja/examples/) - 実践的なサンプルを探索する
- [systemd統合](/ja/guide/systemd) - systemdサービス管理について学ぶ
