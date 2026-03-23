FROM node:20-alpine

# 必要なツールをインストール
RUN apk add --no-cache git bash curl

# Claude Code CLI をグローバルインストール
RUN npm install -g @anthropic-ai/claude-code

# 作業ディレクトリ
WORKDIR /workspace

# エントリーポイント
ENTRYPOINT ["claude"]
CMD ["--help"]
