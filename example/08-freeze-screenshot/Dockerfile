FROM golang:1.24-alpine

# 必要なツールをインストール
RUN apk add --no-cache git bash curl eza bat tree figlet fortune

# freeze をインストール
RUN go install github.com/charmbracelet/freeze@latest

# 作業ディレクトリ
WORKDIR /workspace

# サンプルファイルを作成
RUN mkdir -p src && printf 'package main\n\nimport "fmt"\n\nfunc main() {\n\tfmt.Println("Hello, World!")\n}' > src/main.go

# 出力ディレクトリ
RUN mkdir -p /output

# エントリーポイント
ENTRYPOINT ["/go/bin/freeze"]
CMD ["--help"]
