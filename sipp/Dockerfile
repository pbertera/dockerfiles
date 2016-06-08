FROM alpine:latest
MAINTAINER = Pietro Bertera <pietro@bertera.it>

RUN apk update && apk add build-base bash libgc++ boost-dev\
    libpcap-dev openssl-dev lksctp-tools-dev ncurses-dev \
    && rm -rf /var/cache/apk/*

ADD https://github.com/SIPp/sipp/archive/v3.4.1.tar.gz /
RUN tar -xzf /v3.4.1.tar.gz

WORKDIR /sipp-3.4.1
RUN ./configure --with-pcap --with-sctp --with-openssl --with-rtpstream
RUN make install

WORKDIR /
RUN rm -rf v3.4.1.tar
RUN rm -rf sipp-3.4.1

CMD sipp
