# Evolutionary Meeting Bot - CTO/CEO交替会議で自己進化
# cron + Claude CLI で30分おきに会議を開く

FROM node:20-alpine

# 必要なツールをインストール
RUN apk add --no-cache \
    git bash curl jq \
    dcron tzdata

# Claude Code CLI をインストール
RUN npm install -g @anthropic-ai/claude-code

# 一般ユーザーを作成（デンジャラスモード用）
# nodeユーザー(uid 1000)が存在する場合はuidを変更
RUN adduser -D -u 1001 claude 2>/dev/null || \
    (deluser node 2>/dev/null; adduser -D -u 1000 claude)

# タイムゾーン設定
ENV TZ=Asia/Tokyo

# 作業ディレクトリ
WORKDIR /app

# スクリプトをコピー
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh

# 初期companyファイルをコピー
COPY workspace/company/ /app/workspace/company/

# 出力ディレクトリ（claudeユーザーに所有権を与える）
RUN mkdir -p /workspace/meetings/cto /workspace/meetings/ceo /workspace/deliverables /logs && \
    chown -R claude:claude /workspace /logs /app

# cron ジョブを設定（claudeユーザーとして実行）
COPY crontab /etc/crontabs/claude
RUN chown claude:claude /etc/crontabs/claude

# エントリーポイント
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown claude:claude /entrypoint.sh

# claudeユーザーで実行
USER claude

ENTRYPOINT ["/entrypoint.sh"]
