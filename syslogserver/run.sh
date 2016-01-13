#!/bin/bash

cd /var/www
php5 -f create-user.php
rm -f create-user.php
cd
supervisord
