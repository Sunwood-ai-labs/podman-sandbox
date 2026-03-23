# Freeze Screenshot Example

ターミナル出力とコードをきれいな画像に変換するツール [freeze](https://github.com/charmbracelet/freeze) の Podman 例。

## 概要

Freeze は Charmbracelet 製のツールで、以下の機能を提供:

- コードをシンタックスハイライト付きで画像化
- ターミナル出力（ANSIカラー含む）を画像化
- PNG, SVG, WebP 形式に対応
- ウィンドウ装飾、シャドウ、角丸などカスタマイズ可能

## 実行

```bash
./run.sh
```

## 使用例

### コードを画像化

```bash
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    -o /output/code.png \
    --language go \
    --window \
    --theme dracula \
    main.go
```

### ターミナル出力を画像化

```bash
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "ls -la" \
    -o /output/terminal.png \
    --window
```

### パイプから入力

```bash
cat main.go | podman run --rm -i freeze-screenshot -o /output/main.png
```

## 主なオプション

| オプション | 説明 |
|-----------|------|
| `-o` | 出力ファイル (png/svg/webp) |
| `--window` | macOS風ウィンドウコントロール |
| `--theme` | カラーテーマ (dracula, github など) |
| `--language` | 言語指定 (go, python, bash など) |
| `--border.radius` | 角丸 (px) |
| `--shadow.blur` | シャドウのぼかし |
| `--execute` | コマンドを実行して出力を画像化 |
| `--interactive` | TUIでカスタマイズ |

## クリーンアップ

```bash
./cleanup.sh
```

## 参考

- [freeze - GitHub](https://github.com/charmbracelet/freeze)
