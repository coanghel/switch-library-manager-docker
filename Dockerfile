FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache inotify-tools
RUN mkdir config

COPY switch-library-manager ./switch-library-manager
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
