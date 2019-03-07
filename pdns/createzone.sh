#!/bin/bash

curl -H 'X-API-Key: 1234' -X POST -d @createzone.json http://127.0.0.1:80/api/v1/servers/localhost/zones
curl -H 'X-API-Key: 1234' -X PATCH -d @addrecords.json http://127.0.0.1:80/api/v1/servers/localhost/zones/snomlabo.int
