FROM docker.io/library/claude-code:latest

# 必要なツール
RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# スクリプト配置
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*.sh

# ワークスペース
RUN mkdir -p /workspace /logs

# entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# crontab
COPY crontab /etc/cron.d/claude-cron
RUN chmod 644 /etc/cron.d/claude-cron

ENTRYPOINT ["/entrypoint.sh"]
