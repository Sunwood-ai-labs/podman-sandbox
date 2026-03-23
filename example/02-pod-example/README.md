# 02 - Pod の例

Kubernetes 風の「Pod」単位で複数コンテナを管理する例です。

## 学べること

- `podman pod create` - Pod の作成
- `podman run --pod` - Pod にコンテナを追加
- `podman pod ps` - Pod の一覧表示

## 実行方法

```bash
./run.sh
```

## 実行内容

1. Pod を作成 (ポート 8080 を公開)
2. nginx コンテナを Pod に追加
3. Pod の状態を確認
4. Pod 内のコンテナ一覧を表示

## Pod とは？

Pod は複数のコンテナをグループ化する単位です。
同じ Pod 内のコンテナは:
- 同じネットワーク名前空間を共有
- localhost で相互に通信可能
- 一緒に起動・停止

## ファイル構成

```
02-pod-example/
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
podman pod stop my-pod
podman pod rm my-pod
```
