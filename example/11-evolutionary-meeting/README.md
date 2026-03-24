# 11 - Evolutionary Meeting Bot (CTO/CEO)

会議が自己改善して進化するシステム。CTO会議とCEO会議が30分交替で実行され、組織として成長します。

## 概要

```
┌────────────────────────────────────────────────────┐
│                    時間経過                          │
│                                                     │
│  00分    30分    60分    90分   120分    ...        │
│   ↓       ↓       ↓       ↓       ↓                │
│  CTO →  CEO  →  CTO  →  CEO  →  CTO  → ...        │
│   │       │       │       │       │                │
│   │       └───────┴───────┘       │                │
│   │          ↑ ルール改善 ↑         │                │
│   │          ↑ フォーカス変更 ↑     │                │
│   └──────────┴─ 成果を評価 ─┴──────┘                │
└────────────────────────────────────────────────────┘
```

## 会社情報 (company/)

**Git追跡対象** - 進化の履歴を残す

| ファイル | 内容 | 更新頻度 |
|----------|------|----------|
| `mission.md` | 会社のミッション | 低 |
| `strategy.md` | 戦略・四半期目標 | 中 |
| `meeting-rules.md` | 会議ルール | 高 |
| `focus.md` | 現在のフォーカス | 高 |
| `organization.md` | 組織図・役割 | 低 |
| `history.md` | 会社の沿革 | 継続追記 |

## CTO会議 (毎時0分)

**参照**: `company/` フォルダの全ファイル

**出力**: `meetings/cto/` (Git除外)

**役割**: 技術的な実務会議
- コードレビュー
- 技術調査
- ドキュメント改善
- テスト計画
- など

## CEO会議 (毎時30分)

**更新**: `company/` フォルダのファイル

**出力**: `meetings/ceo/` (Git除外)

**役割**: 戦略・改善会議
- CTO会議の成果を評価
- 会議ルールの改善 (`meeting-rules.md`)
- 次のフォーカス決定 (`focus.md`)
- 戦略見直し (`strategy.md`)
- 沿革への追記 (`history.md`)

## 使い方

```bash
cp .env.example .env
# .env に API キーを設定

./run.sh

# ログ確認
podman logs -f claude-evolution

# CTO会議一覧
ls workspace/meetings/cto/

# CEO会議一覧
ls workspace/meetings/ceo/

# 会社情報確認
cat workspace/company/mission.md
cat workspace/company/focus.md
cat workspace/company/meeting-rules.md

# 履歴確認
cat workspace/company/history.md

# 停止
./cleanup.sh
```

## 出力構成

```
workspace/
├── company/                  # 🏢 Git追跡 (進化の記録)
│   ├── mission.md
│   ├── strategy.md
│   ├── meeting-rules.md
│   ├── organization.md
│   ├── focus.md
│   └── history.md
└── meetings/                 # 📝 Git除外 (議事録)
    ├── cto/
    │   ├── 20260325_1000.md
    │   └── ...
    └── ceo/
        ├── 20260325_1030.md
        └── ...
```

## アジェンダローテーション (CTO会議)

1. コードレビュー
2. 技術調査
3. ドキュメント改善
4. テスト計画
5. アイデア出し
6. リファクタリング
7. セキュリティ確認
8. パフォーマンス最適化

## 進化のイメージ

```
Generation 0 (初期)
├── 会議ルール: 基本ルール
└── フォーカス: サンプルコード品質向上

      ↓ CEO会議で評価・改善

Generation 1
├── 会議ルール: アクションアイテム必須化
└── フォーカス: ドキュメント充実

      ↓ さらに改善

Generation 2
├── 会議ルール: 時間管理強化
└── フォーカス: テスト自動化

      ... 進化継続
```

## Git管理

- **追跡**: `company/` (進化の履歴を残す)
- **除外**: `meetings/` (議事録はローカルのみ)
- **除外**: `.env` (シークレット情報)
