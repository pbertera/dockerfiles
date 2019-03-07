FROM ubuntu:artful
MAINTAINER Pietro Bertera <pietro@bertera.it>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y pdns-backend-sqlite3 pdns-server sqlite3 python3 python3-requests git
RUN mkdir /data/ && cd /data/ && \
    git clone https://github.com/pbertera/PowerDNS-CLI && ln -s /data/PowerDNS-CLI/pdns.py /sbin/pdns.py

EXPOSE 53/tcp
EXPOSE 53/udp

ADD pdns.sql /data/
ADD start.sh /data/

#RUN rm -f /etc/powerdns/pdns.d/pdns.simplebind.conf
RUN rm -f /etc/powerdns/pdns.d/bind.conf
RUN chmod +x /data/start.sh

CMD /data/start.sh
