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
echo "=== Example 1: コードを画像化 ==="
echo "Creating code screenshot..."
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    /output/sample.go \
    -o /output/code.png \
    --language go \
    --window \
    --theme dracula \
    --border.radius 8 \
    --shadow.blur 10

echo "Created: output/code.png"

echo ""
echo "=== Example 2: ターミナル出力を画像化 ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    --execute "ls -la /workspace" \
    -o /output/terminal.png \
    --window \
    --border.radius 8 \
    --shadow.blur 10

echo "Created: output/terminal.png"

echo ""
echo "=== Example 3: SVG 形式で出力 ==="
podman run --rm -v "$PWD/output:/output:Z" freeze-screenshot \
    /output/sample.go \
    -o /output/code.svg \
    --language go \
    --window \
    --theme catppuccin-frappe

echo "Created: output/code.svg"

echo ""
echo "=== 生成されたファイル ==="
ls -la output/

echo ""
echo "Done! Check the output/ directory for screenshots."
