FROM 32bit/ubuntu:14.04

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y net-tools slapd ldap-utils vim nginx  supervisor php5-fpm php5-cli php5-ldap phpldapadmin\
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/listen\ =\ 127.0.0.1:9000/listen\ =\ \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf
RUN sed -i '1idaemon off;' /etc/nginx/nginx.conf

RUN sed -i -e 's/;daemonize\ =\ yes/daemonize\ =\ no/' /etc/php5/fpm/php-fpm.conf
RUN sed -i 's/^variables_order\ =.*/variables_order\ =\ \"GPCSE\"'/ /etc/php5/cli/php.ini

RUN adduser www-data adm

COPY nginx-default /etc/nginx/sites-enabled/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY phpldapadmin-config.php /usr/share/phpldapadmin/config/config.php
COPY start.sh /

RUN chown root:www-data /etc/phpldapadmin/config.php &&\
    chmod 750 /etc/phpldapadmin/config.php

ENV LDAP_ROOTPASS admin
ENV LDAP_ORGANISATION Acme Widgets Inc.
ENV LDAP_DOMAIN example.com

EXPOSE 80 389

CMD ["/start.sh"]
