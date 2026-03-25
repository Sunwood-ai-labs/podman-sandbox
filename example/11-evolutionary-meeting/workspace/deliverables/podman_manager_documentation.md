# Podman Manager スクリプト ドキュメント

## 概要

`podman_manager.sh` は、Podmanコンテナの監視および管理を行うためのスクリプトです。コンテナの起動、停止、状態確認、ログ表示などの基本的な操作に加えて、コンテナの状態を継続的に監視する機能も提供します。最新版では、セキュアなコンテナ作成、リソース監視、詳細な検査など、多くの新機能が追加されました。

## 前提条件

- Podmanがインストールされていること
- Podmanが正しく動作すること
- jqがインストールされていること（詳細なリソース表示のために必要）

## 使用方法

### スクリプトの権限設定

まず、スクリプトに実行権限を付与してください。

```bash
chmod +x podman_manager.sh
```

### 操作コマンド

#### すべてのコンテナを一覧表示

```bash
./podman_manager.sh list
```

#### 特定のコンテナの状態を確認

```bash
./podman_manager.sh status <CONTAINER_ID>
```

#### コンテナを起動

```bash
./podman_manager.sh start <CONTAINER_ID>
```

#### コンテナを停止

```bash
./podman_manager.sh stop <CONTAINER_ID>
```

#### コンテナを再起動

```bash
./podman_manager.sh restart <CONTAINER_ID>
```

#### コンテナのログを表示

```bash
./podman_manager.sh logs <CONTAINER_ID>
```

#### コンテナのログをリアルタイムで表示

```bash
./podman_manager.sh logs <CONTAINER_ID> follow
```

#### すべてのコンテナを継続的に監視

```bash
./podman_manager.sh monitor
```

#### すべてのコンテナのヘルスチェックを実行

```bash
./podman_manager.sh health-check
```

#### 特定のコンテナのヘルスチェックを実行

```bash
./podman_manager.sh health-check <CONTAINER_ID>
```

#### 新しいセキュアなコンテナを作成

```bash
./podman_manager.sh create <IMAGE> <NAME> [OPTIONS]
```

#### 実行中のコンテナでコマンドを実行

```bash
./podman_manager.sh exec <CONTAINER_ID> <COMMAND>
```

#### 停止したコンテナを削除

```bash
./podman_manager.sh remove <CONTAINER_ID>
```

#### コンテナの詳細情報を表示

```bash
./podman_manager.sh inspect <CONTAINER_ID>
```

#### すべてのコンテナのリソース使用状況を表示

```bash
./podman_manager.sh stats
```

#### 詳細なリソース使用状況を表示（アラートしきい値付き）

```bash
./podman_manager.sh stats-detail
```

このコマンドは、CPUとメモリの使用率が指定したしきい値を超えたときに警告を表示するリソースモニタリング機能を提供します。

##### オプションとパラメータ

- `CPU_THRESHOLD`: CPU使用率の警告しきい値（デフォルト: 80%）
- `MEM_THRESHOLD`: メモリ使用率の警告しきい値（デフォルト: 90%）
- `INTERVAL`: 更新間隔（秒単位、デフォルト: 2秒）

##### 使用例

```bash
# デフォルトのしきい値（CPU: 80%, メモリ: 90%）で監視
./podman_manager.sh stats-detail

# カスタムしきい値（CPU: 90%, メモリ: 95%）で監視
./podman_manager.sh stats-detail 90 95

# カスタムしきい値と更新間隔（3秒ごとに更新）で監視
./podman_manager.sh stats-detail 85 90 3
```

#### コンテナイメージのセキュリティスキャン

```bash
./podman_manager.sh security-scan <CONTAINER_NAME>
```

このコマンドは、指定したコンテナイメージをスキャンして脆弱性を検出します。TrivyまたはPodmanの内蔵スキャナーを使用します。

##### オプションとパラメータ

- `CONTAINER_NAME`: スキャン対象のコンテナ名
- `OUTPUT_FORMAT`: 結果の出力形式（table, json, sarif、デフォルト: table）
- `SEVERITY_FILTER`: 表示する脆弱性の重大度（LOW, MEDIUM, HIGH, CRITICAL、デフォルト: HIGH,CRITICAL）
- `LOG_FILE`: 結果を保存するログファイルのパス（デフォルト: security_scan_results.log）

##### 使用例

```bash
# 指定したコンテナのイメージをデフォルト設定でスキャン
./podman_manager.sh security-scan mycontainer

# JSON形式で結果を出力
./podman_manager.sh security-scan mycontainer json

# 高～中程度の脆弱性をフィルタリング
./podman_manager.sh security-scan mycontainer table "HIGH,MEDIUM,Critical" custom_output.log
```

#### バッチ操作

```bash
./podman_manager.sh batch-operation <OPERATION> <REGEX_PATTERN>
```

このコマンドは、正規表現パターンに一致する複数のコンテナに対して一度に操作を実行します。

##### オプションとパラメータ

- `OPERATION`: 実行する操作（start, stop, restart, remove）
- `REGEX_PATTERN`: コンテナ名に一致させる正規表現パターン

##### 使用例

```bash
# 名前が'web'で始まるすべてのコンテナを停止
./podman_manager.sh batch-operation stop '^web.*'

# 名前が'db'を含むすべてのコンテナを再起動
./podman_manager.sh batch-operation restart '.*db.*'

# 名前が'app'で終わるすべてのコンテナを開始
./podman_manager.sh batch-operation start '.*app$'

# 名前が'alpine-'で始まるすべてのコンテナを削除
./podman_manager.sh batch-operation remove '^alpine-.*'
```

#### 未使用のリソースをクリーンアップ

```bash
./podman_manager.sh prune
```

#### ヘルプを表示

```bash
./podman_manager.sh -h
```

または

```bash
./podman_manager.sh --help
```

## 出力

スクリプトの実行結果はコンソールに出力されると同時に、`/tmp/podman_manager.sh.log` にもログとして保存されます。

## 例

### nginxコンテナを安全に作成して起動する例

1. nginxコンテナを安全な設定で作成

```bash
./podman_manager.sh create nginx my-nginx -p 8080:80
```

2. コンテナの状態を確認

```bash
./podman_manager.sh status my-nginx
```

3. コンテナのログを表示

```bash
./podman_manager.sh logs my-nginx
```

4. コンテナを停止

```bash
./podman_manager.sh stop my-nginx
```

5. コンテナを削除

```bash
./podman_manager.sh remove my-nginx
```

### リソース使用状況を監視する例

1. すべてのコンテナのリソース使用状況を表示

```bash
./podman_manager.sh stats
```

2. 詳細なリソース情報を取得

```bash
./podman_manager.sh resources
```

3. 実行中のコンテナでシェルを開く

```bash
./podman_manager.sh exec my-nginx sh
```

## 注意事項

- このスクリプトはPodmanがシステムに正しくインストールされていることを前提としています。
- 一部の操作にはroot権限が必要になる場合があります（rootless Podmanの場合は不要）。
- 実行時のエラー情報はログファイルに保存されます。
- セキュアなコンテナ作成では、読み取り専用ルートファイルシステム、ユーザー名前空間、権限昇格禁止などのセキュリティ設定がデフォルトで適用されます。

## トラブルシューティング

### 一般的な問題

- **コマンドが見つからないエラー**: スクリプトに実行権限が付与されているか確認してください (`chmod +x podman_manager.sh`)
- **Podmanが見つかりません**: Podmanがシステムに正しくインストールされており、PATHに含まれているか確認してください
- **リソース統計が表示されない**: コンテナが実行中であるか確認してください
- **色付けが正しく表示されない**: ターミナルがANSIカラーをサポートしているか確認してください

### 詳細リソースモニタリング (stats-detail) の問題

- **bcが見つかりません**: 詳細な数値比較機能が正しく動作しない場合があります。`bc`コマンドをインストールしてください (`sudo apt install bc` または同等のコマンド)
- **sedが見つかりません**: 詳細統計が正しく動作しない場合があります。`sed`をインストールしてください
- **しきい値アラートが正しく動作しない**: 数値比較の際、小数点以下の扱いで問題が発生する可能性があります。`bc`コマンドのインストールを確認してください

### セキュリティスキャン (security-scan) の問題

- **Trivyが見つかりません**: セキュリティスキャンが失敗する場合はTrivyがインストールされているか確認してください
  - Trivyのインストール: https://aquasecurity.github.io/trivy/
  - Trivyがインストールされていない場合、スクリプトは代替手段を試みます
- **スキャン結果が表示されない**: 出力形式や重大度フィルターが適切に設定されているか確認してください
- **スキャンが失敗する**: コンテナが存在するか、およびコンテナイメージにアクセス可能であるか確認してください

### バッチ操作 (batch-operation) の問題

- **パターンに一致するコンテナが見つからない**: 正規表現パターンが正しいか確認してください
- **操作が一部のコンテナで失敗する**: 個々のコンテナが他の操作によって変更されている可能性があります
- **不正な操作コマンド**: 使用できる操作は start, stop, restart, remove のいずれかのみです

### その他の問題

- **権限エラー**: 一部の操作にはroot権限が必要になる場合があります（rootless Podmanを使用していない場合）
- **ログファイルが生成されない**: ログの出力先ディレクトリに書き込み権限があるか確認してください

## エラー処理

- 存在しないコマンドが指定された場合、ヘルプメッセージが表示されます。
- 必須パラメータが指定されていない場合は、エラーメッセージが表示されます。
- Podmanがインストールされていない場合は、エラーで終了します。
- コンテナが存在しない場合は適切なエラーメッセージが表示されます。