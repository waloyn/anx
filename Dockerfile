FROM alpine:latest

ADD start.sh /opt/start.sh

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x /opt/start.sh

ENTRYPOINT ["sh", "-c", "/opt/start.sh"]
