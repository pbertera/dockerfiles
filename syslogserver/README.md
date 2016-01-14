## Rsyslogd + PimpMyLogs

This container creates a Syslog server with Rsyslogd, logs are accessible via PimpMyLogs interface (http://pimpmylog.com).

PympMylogs credentials are created using the script create-user.php:

`SYSLOG_USERNAME` and `SYSLOG_PASSORD` are used to create credentials.

You can run the container with:

    docker run -it -e SYSLOG_USERNAME=admin -e SYSLOG_PASSWORD=1234 -p 8080:80 -p 514:514/udp pbertera/syslogserver
