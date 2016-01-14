#!/bin/bash

if [ -z $SYSLOG_USERNAME ];then
    export SYSLOG_USERNAME=admin
fi
if [ -z $SYSLOG_PASSWORD ];then
    export SYSLOG_PASSWORD=SyslogP4ss
fi

htpasswd -c -b /etc/nginx/.htpasswd $SYSLOG_USERNAME $SYSLOG_PASSWORD

cd /var/www
php5 -f create-user.php
chown www-data:www-data config.auth.user.php
rm -f create-user.php
cd
supervisord
