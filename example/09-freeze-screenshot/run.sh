#!/bin/bash
set -e

echo "=== Freeze Screenshot Example ==="
echo ""

# イメージビルド
echo "Building freeze container image..."
podman build -t freeze-screenshot .

# 保存用ディレクトリ
mkdir -p output

# サンプルコードを作成
cat > output/sample.go <<'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, Freeze!")
    fmt.Println("Terminal screenshots made easy!")
}
EOF

echo ""
echo "=== Example 1: eza (カラフルな ls) ==="
echo "Creating eza screenshot..."
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "eza -lah --icons --group-directories-first --colour=always /go" \
    -o /output/eza.png \
    --window \
    --border.radius 12 \
    --shadow.blur 15 \
    --margin 30

echo "Created: output/eza.png"

echo ""
echo "=== Example 1b: 通常の ls -al (比較用) ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "ls -al /go" \
    -o /output/ls-al.png \
    --window \
    --border.radius 12 \
    --shadow.blur 15 \
    --margin 30

echo "Created: output/ls-al.png"

echo ""
echo "=== Example 2: tree (ディレクトリ構造 + アイコン) ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "eza --tree --icons --level=2 /go/bin" \
    -o /output/tree.png \
    --window \
    --border.radius 12 \
    --shadow.blur 15 \
    --margin 30

echo "Created: output/tree.png"

echo ""
echo "=== Example 3: figlet (アスキーアート) ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "figlet -f slant 'FREEZE'" \
    -o /output/figlet.png \
    --window \
    --border.radius 12 \
    --shadow.blur 15 \
    --margin 30

echo "Created: output/figlet.png"

echo ""
echo "=== Example 4: figlet + fortune ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "fortune -s | figlet -c" \
    -o /output/fortune.png \
    --window \
    --border.radius 12 \
    --shadow.blur 15 \
    --margin 30

echo "Created: output/fortune.png"

echo ""
echo "=== Example 5: コードを画像化 (Dracula テーマ) ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    /output/sample.go \
    -o /output/code.png \
    --language go \
    --window \
    --theme dracula \
    --border.radius 12 \
    --shadow.blur 15 \
    --show-line-numbers

echo "Created: output/code.png"

echo ""
echo "=== Example 6: figlet 大きなテキスト ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "figlet -f banner 'PODMAN'" \
    -o /output/podman.png \
    --window \
    --border.radius 12 \
    --shadow.blur 15 \
    --margin 30

echo "Created: output/podman.png"

echo ""
echo "=== 生成されたファイル ==="
ls -la output/

echo ""
echo "Done! Check the output/ directory for screenshots."
