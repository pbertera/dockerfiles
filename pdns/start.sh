#!/usr/bin/env bash

if [ -z ${API_KEY+x} ]; then
    API_KEY=changeme
fi  

if [ -z ${WEB_PORT+x} ]; then
    WEB_PORT=8081
fi

# Import schema structure
if [ -e "/data/pdns.sql" ]; then
    cat /data/pdns.sql | sqlite3 /data/pdns.db
    rm /data/pdns.sql
    echo "Imported schema structure"
fi

chown -R pdns:pdns /data/

/usr/sbin/pdns_server \
    --launch=gsqlite3 --gsqlite3-database=/data/pdns.db \
    --webserver=yes --webserver-address=0.0.0.0 --webserver-port=${WEB_PORT} \
    --api=yes --api-key=$API_KEY
