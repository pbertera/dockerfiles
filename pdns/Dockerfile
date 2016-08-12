FROM ubuntu:latest
MAINTAINER Pietro Bertera <pietro@bertera.it>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y pdns-backend-sqlite3 pdns-server sqlite3 

EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 80

ADD pdns.sql /data/
ADD start.sh /data/

RUN rm -f /etc/powerdns/pdns.d/pdns.simplebind.conf
RUN chmod +x /data/start.sh

CMD /data/start.sh
