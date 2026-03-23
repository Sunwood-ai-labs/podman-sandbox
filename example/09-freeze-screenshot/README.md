# Freeze Screenshot Example

ターミナル出力とコードをきれいな画像に変換するツール [freeze](https://github.com/charmbracelet/freeze) の Podman 例。

## 概要

Freeze は Charmbracelet 製のツールで、以下の機能を提供:

- コードをシンタックスハイライト付きで画像化
- ターミナル出力（ANSIカラー含む）を画像化
- PNG, SVG, WebP 形式に対応
- ウィンドウ装飾、シャドウ、角丸などカスタマイズ可能

## 日本語対応

**重要**: 現在の freeze は PNG 出力で日本語 (CJK) に対応していません。
日本語を含む場合は **SVG 出力を推奨** します。

このコンテナは以下の対策を含んでいます：
- [PR #242](https://github.com/charmbracelet/freeze/pull/242) パッチ適用版
- [HackGen](https://github.com/yuru7/HackGen) 日本語フォント搭載

## 実行

```bash
./run.sh
```

## 使用例

### 日本語を含む出力 (SVG 推奨)

```bash
# SVG 出力（日本語対応）
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    -o /output/terminal.svg \
    --language bash \
    --window \
    --theme dracula \
    --font.file /usr/share/fonts/hackgen/HackGenConsoleNF-Regular.ttf \
    input.txt
```

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
    --execute "eza -lah --icons" \
    -o /output/terminal.png \
    --window \
    --border.radius 12 \
    --shadow.blur 15
```

### パイプから入力

```bash
cat main.go | podman run --rm -i freeze-screenshot -o /output/main.png
```

## 主なオプション

| オプション | 説明 |
|-----------|------|
| `-o` | 出力ファイル (**svg** 推奨 / png / webp) |
| `--window` | macOS風ウィンドウコントロール |
| `--theme` | カラーテーマ (dracula, github など) |
| `--language` | 言語指定 (go, python, bash など) |
| `--font.file` | フォントファイル (日本語用) |
| `--border.radius` | 角丸 (px) |
| `--shadow.blur` | シャドウのぼかし |
| `--execute` | コマンドを実行して出力を画像化 |
| `--interactive` | TUIでカスタマイズ |

## 利用可能なフォント

コンテナ内のフォント:
- `/usr/share/fonts/hackgen/HackGenConsoleNF-Regular.ttf`
- `/usr/share/fonts/hackgen/HackGenConsoleNF-Bold.ttf`
- `/usr/share/fonts/hackgen/HackGen35ConsoleNF-Regular.ttf`
- `/usr/share/fonts/hackgen/HackGen35ConsoleNF-Bold.ttf`

## クリーンアップ

```bash
./cleanup.sh
```

## 参考

- [freeze - GitHub](https://github.com/charmbracelet/freeze)
- [PR #242 - CJK サポート](https://github.com/charmbracelet/freeze/pull/242)
- [HackGen フォント](https://github.com/yuru7/HackGen)
