# Evolutionary Meeting Bot
# cron + Claude CLI で定例会議を実行

FROM node:20-alpine

RUN apk add --no-cache \
    git bash curl jq \
    dcron tzdata

RUN npm install -g @anthropic-ai/claude-code

RUN adduser -D -u 1001 claude 2>/dev/null || \
    (deluser node 2>/dev/null; adduser -D -u 1000 claude)

ENV TZ=Asia/Tokyo

WORKDIR /app

COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh

COPY workspace/company/ /app/workspace/company/

RUN mkdir -p /workspace/meetings /workspace/deliverables /logs && \
    chown -R claude:claude /workspace /logs /app

COPY crontab /etc/crontabs/claude
RUN chown claude:claude /etc/crontabs/claude

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown claude:claude /entrypoint.sh

USER claude

ENTRYPOINT ["/entrypoint.sh"]
