FROM alpine:3.19

# 環境変数を表示するシンプルなスクリプト
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'echo "=== Environment Variables ==="' >> /entrypoint.sh && \
    echo 'env | grep -E "^(APP_|DB_|API_)" | sort' >> /entrypoint.sh && \
    echo 'echo ""' >> /entrypoint.sh && \
    echo 'echo "APP_NAME: $APP_NAME"' >> /entrypoint.sh && \
    echo 'echo "APP_ENV: $APP_ENV"' >> /entrypoint.sh && \
    echo 'echo "DB_HOST: $DB_HOST"' >> /entrypoint.sh && \
    echo 'echo "API_KEY: ${API_KEY:0:8}... (masked)"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
