FROM ubuntu:14.04

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y imagemagick vim\
    && rm -rf /var/lib/apt/lists/*

VOLUME /data
WORKDIR /data

ENTRYPOINT ["convert"]
