# 01 - 基本的なコンテナ実行

nginx コンテナを起動してアクセスする最もシンプルな例です。

## 学べること

- `podman pull` - イメージの取得
- `podman run` - コンテナの実行
- `podman ps` - コンテナ一覧の表示

## 実行方法

```bash
./run.sh
```

## 実行内容

1. nginx:alpine イメージを取得
2. コンテナをバックグラウンドで起動 (ポート 8081)
3. コンテナ一覧を表示
4. curl で動作確認

## ファイル構成

```
01-basic-container/
├── README.md   # このファイル
├── run.sh      # 実行スクリプト
└── cleanup.sh  # クリーンアップ
```

## クリーンアップ

```bash
./cleanup.sh
```

または手動で:

```bash
podman stop my-nginx
podman rm my-nginx
```
