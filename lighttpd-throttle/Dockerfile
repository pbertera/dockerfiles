FROM alpine
MAINTAINER "Pietro Bertera" <pietro@bertera.it>

RUN apk add --update lighttpd \
 && rm -rf /var/cache/apk/*

COPY start.sh /

ENTRYPOINT ["/start.sh"]
