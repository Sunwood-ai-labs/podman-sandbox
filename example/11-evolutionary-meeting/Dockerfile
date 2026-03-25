# Evolutionary Meeting Bot
# cron + Claude CLI で定例会議を実行

FROM node:20-alpine

RUN apk add --no-cache \
    git bash curl jq \
    dcron tzdata sudo

RUN npm install -g @anthropic-ai/claude-code

# nodeユーザーを削除して claude ユーザーを uid=1000 で作成
RUN deluser node 2>/dev/null || true && \
    adduser -D -u 1000 claude && \
    echo "claude ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV TZ=Asia/Tokyo

WORKDIR /app

COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh && chown -R claude:claude /app

COPY workspace/company/ /app/workspace/company/

RUN mkdir -p /workspace/meetings /workspace/deliverables /logs && \
    chown -R claude:claude /workspace /logs

COPY crontab /etc/crontabs/claude
RUN chown claude:claude /etc/crontabs/claude

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# root で起動（entrypoint 内で権限設定）
ENTRYPOINT ["/entrypoint.sh"]
