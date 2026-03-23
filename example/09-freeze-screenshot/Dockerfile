FROM golang:1.24-alpine

# 必要なツールをインストール
RUN apk add --no-cache git bash curl eza bat tree figlet fortune unzip

# 日本語フォント (HackGen) をインストール
# https://github.com/yuru7/HackGen
RUN mkdir -p /usr/share/fonts/hackgen && \
    curl -L -o /tmp/hackgen.zip https://github.com/yuru7/HackGen/releases/download/v2.9.0/HackGen_NF_v2.9.0.zip && \
    unzip /tmp/hackgen.zip -d /tmp && \
    cp /tmp/HackGen_NF_v2.9.0/*.ttf /usr/share/fonts/hackgen/ && \
    rm -rf /tmp/hackgen* /tmp/HackGen* && \
    ls -la /usr/share/fonts/hackgen/

# PR #242 (CJK サポート) パッチ適用版をビルド
# https://github.com/charmbracelet/freeze/pull/242
RUN git clone --depth 1 -b fix/load-system-fonts https://github.com/Wangnov/freeze.git /tmp/freeze && \
    cd /tmp/freeze && \
    go install ./...

# 作業ディレクトリ
WORKDIR /workspace

# サンプルファイルを作成
RUN mkdir -p src && printf 'package main\n\nimport "fmt"\n\nfunc main() {\n\tfmt.Println("Hello, World!")\n}' > src/main.go

# 出力ディレクトリ
RUN mkdir -p /output

# エントリーポイント
ENTRYPOINT ["freeze"]
CMD ["--help"]
