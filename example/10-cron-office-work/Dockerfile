# Claude Office Worker - 定時会議ボット
# cron + Claude CLI で1時間おきに会議を開く

FROM node:20-alpine

# 必要なツールをインストール
RUN apk add --no-cache \
    git bash curl jq \
    dcron tzdata

# Claude Code CLI をインストール
RUN npm install -g @anthropic-ai/claude-code

# タイムゾーン設定
ENV TZ=Asia/Tokyo

# 作業ディレクトリ
WORKDIR /app

# スクリプトをコピー
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh

# 出力ディレクトリ
RUN mkdir -p /reports /workspace

# cron ジョブを設定
COPY crontab /etc/crontabs/root

# エントリーポイント
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
