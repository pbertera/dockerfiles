#!/bin/sh

cd /opt/deadwood
cat dwoodrc.tpl | envsubst > dwood.rc

./Deadwood -f dwood.rc
