FROM 32bit/ubuntu:14.04

RUN apt-get update \
    && apt-get install -y git net-tools vim nginx rsyslog supervisor php5-fpm php5-cli\
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/listen\ =\ 127.0.0.1:9000/listen\ =\ \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf
RUN sed -i '1idaemon off;' /etc/nginx/nginx.conf

RUN rm -rf /var/www && git clone https://github.com/potsky/PimpMyLog.git /var/www
RUN sed -i -e 's/;daemonize\ =\ yes/daemonize\ =\ no/' /etc/php5/fpm/php-fpm.conf
RUN sed -i 's/^variables_order\ =.*/variables_order\ =\ \"GPCSE\"'/ /etc/php5/cli/php.ini

RUN sed -i -e 's/#$ModLoad\ imudp/$ModLoad\ imudp/' -e 's/#$UDPServerRun\ 514/$UDPServerRun\ 514/' /etc/rsyslog.conf
RUN sed -i -e 's/$ActionFileDefaultTemplate\ RSYSLOG_TraditionalFileFormat/$ActionFileDefaultTemplate\ RSYSLOG_SyslogProtocol23Format/' /etc/rsyslog.conf

RUN mkdir -p /var/log/net/
RUN chown syslog:adm /var/log/net/
RUN adduser www-data adm

COPY nginx-default /etc/nginx/sites-enabled/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config.user.php /var/www/
COPY rsyslog.conf /etc/rsyslog.conf
COPY create-user.php /var/www/
COPY run.sh /

RUN cd /var/www && php5 -f ./create-user.php && chown www-data:www-data config.auth.user.php 

EXPOSE 80 514/udp

CMD ["/run.sh"]
