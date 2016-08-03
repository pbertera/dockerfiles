FROM debian:jessie

MAINTAINER Pietro Bertera <pietro@bertera.it>
ENV SNGREP_VERSION v1.3.1

# installation of packets needed for installation
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential git automake ncurses-dev libncursesw5-dev libssl-dev libpcre3-dev libpcap-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /build && \
    cd /build && \
    GIT_SSL_NO_VERIFY=true git clone https://github.com/irontec/sngrep && \
    cd sngrep && git checkout $SNGREP_VERSION && \
    ./bootstrap.sh && ./configure && make && make install


ENTRYPOINT [ "sngrep" ]
