# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Podman と Docker の比較調査・学習用リポジトリ。Podman の基本的な使い方を示す実行可能なサンプル集。

## コマンド

### 実行・クリーンアップ
```bash
# 各サンプルの実行
cd example/XX-example && ./run.sh

# クリーンアップ
./cleanup.sh

# 全体クリーンアップ
podman rm -af && podman rmi -af && podman pod rm -af
```

### Podman 基本コマンド
```bash
podman ps -a          # コンテナ一覧
podman images         # イメージ一覧
podman pod ps         # Pod 一覧
podman stats          # リソース使用量
podman logs <name>    # ログ確認
```

### ビルド・実行
```bash
podman build -t <name> .                    # Dockerfile ビルド
podman run -d --name <name> <image>         # コンテナ実行
podman run --env-file .env <image>          # .env 読み込み
podman-compose up -d                        # compose 実行
```

## アーキテクチャ

### サンプル構成
```
example/
├── 01-basic-container/    # 基本的なコンテナ実行 (nginx)
├── 02-pod-example/        # Pod: 複数コンテナをグループ化
├── 03-systemd-service/    # systemd 統合: コンテナをサービス化
├── 04-dockerfile-example/ # Dockerfile からビルド
├── 05-claudecode-example/ # Claude Code CLI 内蔵コンテナ
├── 06-envfile-example/    # .env ファイルで環境変数管理
└── 07-compose-example/    # docker-compose.yml 互換
```

### 各サンプルの構造
- `run.sh` - 実行スクリプト (set -e でエラー時停止)
- `cleanup.sh` - クリーンアップスクリプト
- `Dockerfile` - 必要に応じて (04, 05, 06)
- `README.md` - 説明

### Podman vs Docker
- デーモンレス設計 (dockerd 不要)
- デフォルトで rootless 実行
- `docker` コマンドと互換性あり (podman run ≒ docker run)
- systemd とのネイティブ統合

## 開発時の注意

- イメージは `docker.io/library/` から明示的に取得
- systemd 統合は `~/.config/systemd/user/` にサービスファイル生成
- Pod は Kubernetes 風のコンテナグループ (localhost 通信可能)

## コミットルール

### 都度コミット
タスク完了ごとにコミットを作成する。大きな変更を溜め込まず、作業単位でこまめにコミットする。

```bash
# 変更確認
git status
git diff

# ステージング & コミット
git add <files>
git commit -m "feat: 新機能の追加"
```

### .env ファイルの除外
**`.env` ファイルは絶対にコミットしないこと**（シークレット情報漏洩防止）

```bash
# .env が含まれていないか必ず確認
git status | grep -E "\.env$"

# 万が一ステージングされていたら除外
git reset HEAD -- .env
```

`.gitignore` に `.env` が含まれていることを確認すること。

## チームワークフロー

タスク実行時は、以下の手順で最適なチームを編成し、チームで処理する：

### チーム編成手順

1. **タスク分析**: ユーザーリクエストを解析し、必要なスキル・役割を特定
2. **チーム作成**: `TeamCreate` でチームを作成
3. **メンバー選定**: タスクの性質に応じて最適なエージェントタイプを選択
4. **タスク分割**: QAインベントリに基づき、漏れなくタスクを分割・登録
5. **並列実行**: 独立したタスクは並列で実行し、効率化を図る
6. **統合・確認**: 全タスク完了後、成果物を統合して品質確認

### QAインベントリ活用

チームメンバーへの指示には QAインベントリを活用し、以下を保証する：

| チェック項目 | 説明 |
|-------------|------|
| 要件網羅性 | ユーザー要求が全てタスクに反映されているか |
| 完了条件明確化 | 各タスクの完了条件が明確に定義されているか |
| 依存関係整理 | タスク間の依存関係が正しく設定されているか |
| テスト可能性 | 実装結果が検証可能な形になっているか |
| ドキュメント更新 | 必要なドキュメント更新が含まれているか |

### エージェントタイプの使い分け

| タイプ | 用途 |
|--------|------|
| `general-purpose` | 実装・コード変更・複雑なタスク |
| `Explore` | コードベース調査・情報収集 |
| `Plan` | 設計・計画作成 |

### 指示テンプレート

チームメンバーへの指示は以下の形式で明確に：

```
タスク: [具体的なタスク内容]
完了条件: [いつ完了とするか]
入力: [必要な情報・ファイル]
出力: [期待される成果物]
注意点: [特に気をつけるべき点]
```
