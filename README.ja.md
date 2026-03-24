<p align="center">
  <img src="docs/images/podman-sandbox-icon.svg" alt="Podman Sandbox Logo" width="128" height="128">
</p>

<h1 align="center">Podman Sandbox</h1>

<p align="center">
  <strong>Podman と Docker の比較調査・学習用リポジトリ</strong>
</p>

<p align="center">
  <a href="README.md">English</a> | <strong>日本語</strong>
</p>

<p align="center">
  <a href="https://github.com/Sunwood-ai-labs/podman-sandbox/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/Sunwood-ai-labs/podman-sandbox?style=flat-square&color=blue" alt="License">
  </a>
  <a href="https://github.com/Sunwood-ai-labs/podman-sandbox">
    <img src="https://img.shields.io/badge/GitHub-podman--sandbox-892ca0?style=flat-square&logo=github" alt="GitHub">
  </a>
  <a href="https://sunwood-ai-labs.github.io/podman-sandbox/">
    <img src="https://img.shields.io/badge/Docs-VitePress-892ca0?style=flat-square&logo=googledocs" alt="Docs">
  </a>
</p>

---

## 目次

- [概要](#概要)
- [主な特徴](#-主な特徴)
- [アーキテクチャの違い](#-アーキテクチャの違い)
- [メモリ効率の比較](#-メモリ効率の比較)
- [systemd 統合](#-systemd-統合)
- [サンプル一覧](#-サンプル一覧)
- [基本的な使い方](#-基本的な使い方)
- [まとめ](#-まとめ)
- [参考資料](#-参考資料)

---

## 概要

**Podman** は Red Hat が開発したコンテナランタイムで、Docker の代替として使用できるツールです。

### 主な特徴

<table>
<tr>
<td width="72" align="center">
<img src="https://fonts.gstatic.com/sv/symbols/material_symbols_outlined/dns_off/v1-72px.svg#892ca0" width="48" height="48" alt="Daemonless">
</td>
<td>
<strong>デーモンレス</strong><br>
<small>バックグラウンドで動くデーモンが不要</small>
</td>
</tr>
<tr>
<td width="72" align="center">
<img src="https://fonts.gstatic.com/sv/symbols/material_symbols_outlined/lock_open/v1-72px.svg#892ca0" width="48" height="48" alt="Rootless">
</td>
<td>
<strong>ルートレス</strong><br>
<small>root 権限なしでコンテナを実行可能</small>
</td>
</tr>
<tr>
<td width="72" align="center">
<img src="https://fonts.gstatic.com/sv/symbols/material_symbols_outlined/sync/v1-72px.svg#892ca0" width="48" height="48" alt="Docker Compatible">
</td>
<td>
<strong>Docker 互換</strong><br>
<small>docker コマンドとほぼ同じ構文</small>
</td>
</tr>
<tr>
<td width="72" align="center">
<img src="https://fonts.gstatic.com/sv/symbols/material_symbols_outlined/view_module/v1-72px.svg#892ca0" width="48" height="48" alt="Pod Support">
</td>
<td>
<strong>Pod 対応</strong><br>
<small>Kubernetes 風の「Pod」単位でコンテナを管理</small>
</td>
</tr>
<tr>
<td width="72" align="center">
<img src="https://fonts.gstatic.com/sv/symbols/material_symbols_outlined/settings_suggest/v1-72px.svg#892ca0" width="48" height="48" alt="systemd">
</td>
<td>
<strong>systemd 統合</strong><br>
<small>コンテナを systemd サービスとして管理</small>
</td>
</tr>
</table>

---

## アーキテクチャの違い

| 項目 | Docker | Podman |
|------|--------|--------|
| アーキテクチャ | クライアント・サーバーモデル（デーモン必要） | デーモンレス（フォーク・エグゼックモデル） |
| 常駐プロセス | `dockerd` が常時実行 | なし |
| 実行権限 | デフォルトで root（rootless モードあり） | デフォルトで rootless |
| セキュリティ | デーモンが攻撃対象になる可能性 | 攻撃対象が少ない |

---

## メモリ効率の比較

### 結論

**Podman の方がメモリ効率が良い傾向がある**

### 理由

#### 1. デーモンレス設計

| | Docker | Podman |
|--|--------|--------|
| アイドル時 | `dockerd` がメモリを消費し続ける | メモリ消費なし |
| 起動フロー | CLI → デーモン → コンテナ | CLI → 直接コンテナ |
| ベースオーバーヘッド | 高い（デーモン + コンテナ） | 低い（デーモンなし） |

Docker はバックグラウンドで `dockerd` が常に動いており、コンテナが 1 つもなくてもメモリを消費します。
Podman はデーモンがないので、コンテナ実行時のみリソースを使います。

#### 2. Rootless 実行の最適化

- **Podman**: 最初から rootless で設計されており、非特権ユーザーでの実行が効率的
- **Docker**: rootless モードは後付けで、オーバーヘッドが大きめ

#### 3. プロセスモデル

- **Podman**: 各コンテナが直接 `podman` プロセスの子として動作（fork-exec）
- **Docker**: デーモン経由で管理されるため、余分なレイヤーがある

### シナリオ別の比較

| シナリオ | 有利な方 |
|----------|----------|
| 少数のコンテナ | Podman（デーモンオーバーヘッドなし） |
| 大量のコンテナ同時実行 | Docker（デーモン共有で効率化） |
| Rootless 実行 | Podman（ネイティブ対応） |
| 開発環境での手軽さ | どちらも同等 |

### メモリ使用量の確認方法

```bash
# Podman
podman stats

# Docker
docker stats
```

---

## systemd 統合

Podman は systemd との統合が強力で、コンテナを systemd サービスとして管理できます。

### コンテナの systemd サービス化

```bash
# コンテナから systemd サービスファイルを生成
podman generate systemd --name my-container

# --new オプションで再起動時に新しいコンテナを作成
podman generate systemd --new --name my-container
```

### Pod のサービス化

```bash
# Pod ごと systemd サービス化
podman generate systemd --pod --name my-pod
```

### サービス管理

```bash
# サービスとして有効化
systemctl enable container-myapp

# 起動・停止・再起動
systemctl start container-myapp
systemctl stop container-myapp
systemctl restart container-myapp

# ステータス確認
systemctl status container-myapp
```

### Docker との比較

| 機能 | Docker | Podman |
|------|--------|--------|
| systemd 統合 | `--restart` ポリシーのみ | ネイティブ統合、サービスファイル生成可 |
| サービス管理 | docker デーモン経由 | systemctl で直接管理 |
| 起動順序制御 | 限定 | systemd の依存関係をフル活用 |
| ログ管理 | 独自 | journalctl と統合可能 |

### 実用例：コンテナをシステムサービスとして運用

```bash
# 1. コンテナ作成
podman run -d --name webapp -p 8080:80 nginx

# 2. systemd サービス生成
podman generate systemd --name webapp --new > /etc/systemd/system/container-webapp.service

# 3. systemd で有効化
systemctl daemon-reload
systemctl enable --now container-webapp
```

これで、**サーバー再起動時も自動的にコンテナが立ち上がり**、`systemctl` で完全に管理できます。

---

## サンプル一覧

| サンプル | 説明 |
|----------|------|
| [01-basic-container](example/01-basic-container/) | 基本的なコンテナ実行 (nginx) |
| [02-pod-example](example/02-pod-example/) | Pod: 複数コンテナをグループ化 |
| [03-systemd-service](example/03-systemd-service/) | systemd 統合: コンテナをサービス化 |
| [04-dockerfile-example](example/04-dockerfile-example/) | Dockerfile からビルド |
| [05-claudecode-example](example/05-claudecode-example/) | Claude Code CLI 内蔵コンテナ |
| [06-envfile-example](example/06-envfile-example/) | .env ファイルで環境変数管理 |
| [07-compose-example](example/07-compose-example/) | docker-compose.yml 互換 |
| [08-compose-claudecode](example/08-compose-claudecode/) | Claude Code + Alibaba Qwen compose |
| [09-freeze-screenshot](example/09-freeze-screenshot/) | freeze でターミナルスクリーンショット |
| [10-cron-office-work](example/10-cron-office-work/) | Claude Meeting Bot (cron + AI) |

---

## 基本的な使い方

```bash
# イメージを取得
podman pull ubuntu

# コンテナを実行
podman run -it ubuntu /bin/bash

# コンテナ一覧
podman ps -a

# イメージ一覧
podman images

# コンテナの削除
podman rm <container_id>

# イメージの削除
podman rmi <image_id>
```

### Docker コマンドとの互換性

ほとんどの `docker` コマンドは `podman` に置き換えるだけで動作します：

```bash
# Docker
docker run -d -p 80:80 nginx

# Podman（同じように動作）
podman run -d -p 80:80 nginx
```

---

## まとめ

| 項目 | 推奨 |
|------|------|
| 少数のコンテナを効率的に運用したい | Podman |
| Rootless で安全にコンテナを実行したい | Podman |
| systemd と連携してサービス管理したい | Podman |
| 大量のコンテナを同時に実行する環境 | Docker も検討 |
| 既存の Docker エコシステムを活用 | Docker |

**Podman は「コンテナを systemd のネイティブサービスとして扱える」「メモリ効率が良い」「セキュリティが高い」** のが大きな強みです。

---

## 参考資料

- [Podman 公式ドキュメント](https://podman.io/)
- [Red Hat - Podman 入門](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/building_running_and_managing_containers)
- [Podman GitHub](https://github.com/containers/podman)
