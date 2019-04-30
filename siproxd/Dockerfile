
FROM alpine:3.9
RUN apk update
RUN apk add gcc libc-dev libtool autoconf automake make
RUN mkdir -p /tmp/build
COPY build.sh /tmp/build/build.sh
COPY siproxd-001.patch /tmp/build/siproxd-001.patch
COPY siproxd-002.patch /tmp/build/siproxd-002.patch
RUN cd /tmp/build && ./build.sh
RUN rm -rf /tmp/build

ENTRYPOINT ["/usr/local/sbin/siproxd"]
