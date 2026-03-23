# 08 - Claude Code + Alibaba Qwen 統合例

`podman-compose` で Claude Code コンテナを実行し、Alibaba Cloud Qwen モデルを使用する例です。

## 学べること

- Alibaba Cloud Coding Plan の Anthropic 互換 API の使用
- docker-compose.yml での環境変数管理
- .env ファイルでの API キー管理
- Qwen モデルの使い分け

## 公式ドキュメント

- [Claude Code - Alibaba Cloud Model Studio](https://www.alibabacloud.com/help/en/model-studio/claude-code)

**重要**: Coding Plan ユーザーは専用のエンドポイントを使用する必要があります。

## ファイル構成

```
08-compose-claudecode/
├── README.md          # このファイル
├── docker-compose.yml # Compose ファイル
├── Dockerfile         # Claude Code 内蔵イメージ
├── .env.example       # 環境変数サンプル
├── .env               # 実際の環境変数 (git 管理外)
├── run.sh             # 実行スクリプト
└── cleanup.sh         # クリーンアップ
```

## 前提条件

```bash
# podman-compose のインストール
sudo apt install -y podman-compose

# または pip で
pip install podman-compose
```

## セットアップ

### 1. Alibaba Cloud API キーの取得

1. [Alibaba Cloud Model Studio Console](https://dashscope.console.aliyun.com/) にアクセス
2. **Coding Plan** を契約している場合、専用のエンドポイントと API キーが提供されます
3. Plan Exclusive Base URL: `https://coding-intl.dashscope.aliyuncs.com/apps/anthropic`

### 2. .env ファイルの作成

```bash
# .env.example をコピー
cp .env.example .env

# API キーを設定
vim .env
```

### 3. .env ファイルの内容

```env
# Alibaba Cloud Coding Plan API キー (必須)
# Coding Plan 用の専用 API キーを使用
ALIBABA_API_KEY=sk-your-coding-plan-api-key-here

# 使用する Qwen モデル
CLAUDE_MODEL=qwen3-coder-plus

# 作業ディレクトリ
WORKSPACE_PATH=/path/to/your/project
```

## 利用可能なモデル

| モデル | 用途 | 特徴 |
|--------|------|------|
| `qwen3-coder-plus` | コーディング | 推奨、安定版 |
| `qwen3-coder-next` | コーディング | 最新、高精度 |
| `qwen3.5-plus` | 複雑なタスク | バランス型 |
| `qwen3-max` | 最も複雑なタスク | thinking mode 対応 |
| `qwen-turbo` | 単純タスク | 最高速 |
| `qwen3.5-flash` | 単純タスク | 低コスト |

## 実行方法

### 自動実行 (推奨)

```bash
./run.sh
```

### 手動実行

```bash
# ビルド
podman-compose build

# ヘルプ表示
podman-compose run --rm claudecode --help

# Qwen に質問
podman-compose run --rm claudecode -p "Hello, Qwen!"
```

### モデルを指定して実行

```bash
# コーディングタスク (デフォルト)
podman-compose run --rm claudecode -p "Write a Python hello world"

# 複雑なタスク
podman-compose run --rm -e ANTHROPIC_MODEL=qwen3.5-plus claudecode -p "Design a system architecture"

# 高速レスポンス
podman-compose run --rm -e ANTHROPIC_MODEL=qwen-turbo claudecode -p "Quick question"
```

### インタラクティブモード

```bash
podman-compose run -it claudecode
```

## トラブルシューティング

### "Unable to connect to Anthropic services"

環境変数が正しく設定されているか確認:

```bash
podman-compose run --rm claudecode env | grep ANTHROPIC
```

### API キーエラー

- Coding Plan 用の専用 API キーを使用しているか確認
- API キーが有効か [Console](https://dashscope.console.aliyun.com/) で確認
- エンドポイントが `coding-intl.dashscope.aliyuncs.com` であるか確認

### トークン消費が早い

- `/compact` で会話履歴を要約
- `/clear` でコンテキストをリセット
- 不要なファイルをプロジェクトディレクトリから除外

## セキュリティ注意点

| 項目 | 説明 |
|------|------|
| .env は git 管理外 | API キーが漏洩しないよう除外済み |
| Coding Plan 専用エンドポイント | `coding-intl.dashscope.aliyuncs.com` を使用 |
| API キーは秘密 | 公開しないよう注意 |

## クリーンアップ

```bash
./cleanup.sh
```
