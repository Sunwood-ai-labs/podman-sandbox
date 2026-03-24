# サンプル

Podmanの実践的なサンプル集を参照してください。

## 基本サンプル

| サンプル | 説明 | 難易度 |
|----------|------|--------|
| [01-basic-container](/ja/examples/01-basic-container) | 基本的なnginxコンテナ | 🟢 初級 |
| [02-pod-example](/ja/examples/02-pod-example) | マルチコンテナPod | 🟡 中級 |
| [03-systemd-service](/ja/examples/03-systemd-service) | systemd統合 | 🟡 中級 |
| [04-dockerfile-example](/ja/examples/04-dockerfile-example) | カスタムDockerfile | 🟡 中級 |

## 上級サンプル

| サンプル | 説明 | 難易度 |
|----------|------|--------|
| [05-claudecode-example](/ja/examples/05-claudecode-example) | コンテナ内のClaude Code | 🔴 上級 |
| [06-envfile-example](/ja/examples/06-envfile-example) | 環境変数管理 | 🟡 中級 |
| [07-compose-example](/ja/examples/07-compose-example) | Docker Compose互換 | 🟡 中級 |
| [08-compose-claudecode](/ja/examples/08-compose-claudecode) | マルチサービスcompose | 🔴 上級 |
| [09-freeze-screenshot](/ja/examples/09-freeze-screenshot) | ターミナルスクリーンショット | 🟡 中級 |
| [10-cron-office-work](/ja/examples/10-cron-office-work) | Cron + AI自動化 | 🔴 上級 |

## クイックスタート

各サンプルには以下が含まれます：
- `run.sh` - サンプルを起動
- `cleanup.sh` - リソースをクリーンアップ
- `README.md` - 詳細な手順

## サンプルの実行

```bash
cd example/01-basic-container
./run.sh
```

## クリーンアップ

```bash
cd example/01-basic-container
./cleanup.sh
```

## 全体クリーンアップ

```bash
podman rm -af && podman rmi -af && podman pod rm -af
```
