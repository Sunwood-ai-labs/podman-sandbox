# 05 - ClaudeCode 内蔵コンテナ

Podman コンテナ内で Claude Code CLI を実行する例です。

## 学べること

- Node.js ベースイメージの使用
- npm グローバルインストール
- 環境変数での API キー受け渡し
- インタラクティブなコンテナ実行

## ファイル構成

```
05-claudecode-example/
├── README.md      # このファイル
├── Dockerfile     # ClaudeCode 内蔵イメージ
├── run.sh         # 実行スクリプト
└── cleanup.sh     # クリーンアップ
```

## 前提条件

- Anthropic API キーが必要です
- 環境変数 `ANTHROPIC_API_KEY` を設定してください

```bash
export ANTHROPIC_API_KEY=your-api-key-here
```

## 実行方法

### ビルド

```bash
podman build -t claudecode ./example/05-claudecode-example
```

### ヘルプ表示

```bash
podman run --rm claudecode --help
```

### インタラクティブモード

```bash
podman run -it --rm \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -v $(pwd):/workspace \
  claudecode
```

### ワンライナーで実行

```bash
podman run --rm \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  claudecode "Hello, Claude!"
```

## セキュリティ注意点

- API キーは環境変数で渡す（イメージにハードコードしない）
- 機密情報を含むコンテナは公開しない
- 本番環境では Secret 管理を検討

## クリーンアップ

```bash
./cleanup.sh
```
