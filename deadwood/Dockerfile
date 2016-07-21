FROM alpine:latest

RUN apk update && apk add git gcc make libc-dev gettext
RUN mkdir /tmp/deadwood && cd /tmp/deadwood \
    && git clone https://github.com/samboy/MaraDNS \
    && cd MaraDNS/deadwood-github/src && make \
    && mkdir -p /opt/deadwood && cp Deadwood /opt/deadwood

COPY dwoodrc.tpl /opt/deadwood
COPY start.sh /

EXPOSE 53/udp
CMD ["/start.sh"]

