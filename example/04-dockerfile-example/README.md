# 04 - Dockerfile ビルド

Dockerfile からイメージをビルドして実行する例です。

## 学べること

- `podman build` - Dockerfile からイメージをビルド
- `podman run --rm` - 実行後に自動削除
- `podman rmi` - イメージの削除

## ファイル構成

```
04-dockerfile-example/
├── README.md      # このファイル
├── Dockerfile     # ビルド定義
├── run.sh         # 実行スクリプト
└── cleanup.sh     # クリーンアップ
```

## 実行方法

```bash
./run.sh
```

## 実行内容

1. 同ディレクトリの Dockerfile からイメージをビルド
2. コンテナを実行 (httpbin.org にアクセス)

## Dockerfile の内容

```dockerfile
FROM alpine:3.19
RUN apk add --no-cache curl
CMD ["curl", "-s", "https://httpbin.org/get"]
```

## Docker との互換性

Podman は Dockerfile をそのまま使用できます。
`docker build` → `podman build` に置き換えるだけで動作します。

## 手動でビルドする場合

```bash
# ビルド
podman build -t my-curl-app .

# 実行
podman run --rm my-curl-app

# 削除
podman rmi my-curl-app
```
