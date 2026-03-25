# 11 - Evolutionary Meeting Bot

CEOが実装と振り返りを繰り返して自己改善するシステム。

## 概要

```
毎時00分
   ↓
┌─────────────────────────┐
│  CEO会議                │
│  1. やることを決める     │
│  2. 実装する            │
│  3. 振り返り・改善する   │
│  4. プッシュ            │
└─────────────────────────┘
   ↓ (1時間後)
  繰り返し
```

## 会社情報 (company/)

| ファイル | 内容 |
|----------|------|
| `mission.md` | 会社のミッション |
| `strategy.md` | 戦略・目標 |
| `focus.md` | 現在のフォーカス |
| `history.md` | 沿革（追記） |

## 使い方

```bash
cp .env.example .env
# .env に API キーを設定

./run.sh

# ログ確認
podman logs -f claude-evolution

# 会議一覧
ls workspace/meetings/

# 会社情報確認
cat workspace/company/focus.md

# 停止
./cleanup.sh
```

## 出力構成

```
workspace/
├── company/          # 会社情報（進化の記録）
│   ├── mission.md
│   ├── strategy.md
│   ├── focus.md
│   └── history.md
├── meetings/         # 議事録
│   └── 20260325_1000.md
└── deliverables/     # 成果物
```
