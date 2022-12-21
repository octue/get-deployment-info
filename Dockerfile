FROM alpine:3.17.0

RUN apk update && apk add --no-cache curl git && rm -rf /var/cache/apk/*

COPY get_deployment_info/entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
