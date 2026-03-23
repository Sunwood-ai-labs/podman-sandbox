# 03 - systemd 統合

コンテナを systemd サービスとして管理する例です。
サーバー再起動時も自動的にコンテナが立ち上がります。

## 学べること

- `podman create` - コンテナの作成（起動しない）
- `podman generate systemd` - サービスファイル生成
- `systemctl --user` - ユーザーサービスの管理

## 実行方法

```bash
./run.sh
```

## 実行内容

1. コンテナを作成（まだ起動しない）
2. systemd サービスファイルを生成
3. systemd でサービスを有効化・起動
4. ステータス確認

## 利点

- `systemctl` で完全に管理可能
- サーバー再起動時に自動起動
- 他の systemd サービスとの依存関係を設定可能
- `journalctl` でログ管理

## ファイル構成

```
03-systemd-service/
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
systemctl --user stop container-systemd-nginx
systemctl --user disable container-systemd-nginx
rm ~/.config/systemd/user/container-systemd-nginx.service
systemctl --user daemon-reload
podman rm systemd-nginx
```

## 注意

この例は systemd が動作している環境で有効です。
