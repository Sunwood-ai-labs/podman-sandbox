# 06 - 環境変数ファイル (.env) の読み込み

Podman で `.env` ファイルを読み込んで環境変数をコンテナに渡す例です。

## 学べること

- `--env-file` オプションの使い方
- `.env` ファイルの書き方
- 環境変数のマスキング（セキュリティ）

## ファイル構成

```
06-envfile-example/
├── README.md       # このファイル
├── Dockerfile      # 環境変数表示用イメージ
├── .env.example    # サンプル .env ファイル
├── run.sh          # 実行スクリプト
└── cleanup.sh      # クリーンアップ
```

## 準備

```bash
# サンプルをコピー
cp .env.example .env

# 必要に応じて編集
vim .env
```

## 実行方法

### 方法1: --env-file オプション

```bash
podman run --rm --env-file .env env-demo
```

### 方法2: -e で個別に渡す

```bash
podman run --rm \
  -e APP_NAME=my-app \
  -e APP_ENV=production \
  env-demo
```

### 方法3: 複数の env ファイル

```bash
podman run --rm \
  --env-file .env.common \
  --env-file .env.local \
  env-demo
```

## .env ファイルの書き方

```bash
# コメントは無視される
APP_NAME=my-app

# = を含む値はクォート
DB_URL="postgresql://host:5432/db"

# 未定義変数は空文字
# UNDEFINED_VAR=

# 複数行は不可（1行1変数）
```

## セキュリティ注意点

- `.env` ファイルは **Git にコミットしない**（`.gitignore` に追加）
- 本番環境では Secret 管理ツールを検討
- API キーなどはログに出力しない

## クリーンアップ

```bash
./cleanup.sh
```
