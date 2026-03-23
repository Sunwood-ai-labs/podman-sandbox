FROM golang:1.24-alpine

# 必要なツールをインストール
RUN apk add --no-cache git bash

# freeze をインストール
RUN go install github.com/charmbracelet/freeze@latest

# 作業ディレクトリ
WORKDIR /workspace

# 出力ディレクトリ
RUN mkdir -p /output

# エントリーポイント
ENTRYPOINT ["/go/bin/freeze"]
CMD ["--help"]
