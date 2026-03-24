---
layout: home
hero: true
title: Podman Sandbox
description: Podmanの学習用リポジトリ - Docker との比較調査を通じて実践的に学ぶ
features:
  - icon: <span class="material-symbols-outlined icon-feature">dns_off</span>
    title: デーモンレス
    details: バックグラウンドデーモンが不要
  - icon: <span class="material-symbols-outlined icon-feature">lock_open</span>
    title: ルートレス
    details: root権限なしでコンテナを実行可能
  - icon: <span class="material-symbols-outlined icon-feature">sync</span>
    title: Docker互換
    details: dockerコマンドとほぼ同じ構文
  - icon: <span class="material-symbols-outlined icon-feature">view_module</span>
    title: Pod対応
    details: Kubernetes風のPod単位でコンテナ管理
  - icon: <span class="material-symbols-outlined icon-feature">settings_suggest</span>
    title: systemd統合
    details: コンテナをsystemdサービスとして管理
---

## Podmanについて

PodmanはRed Hatが開発したコンテナランタイムで、Dockerの代替として使用できるツールです。

## クイックリンク

- [始めよう](/ja/guide/getting-started) - Podmanでコンテナを実行
- [アーキテクチャ](/ja/guide/architecture) - PodmanとDockerの違いを理解
- [サンプル](/ja/examples/) - 実践的なサンプルを参照
- [systemd統合](/ja/guide/systemd) - systemdサービス管理について学ぶ

<style>
.icon-feature {
  font-size: 48px;
  color: #892ca0;
}
</style>
