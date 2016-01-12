<?php
# Create a default admin user
include 'inc/global.inc.php';
include 'inc/classes/Sentinel.php';

Sentinel::init();
Sentinel::create();
Sentinel::setAdmin('admin','SyslogP4ss');
Sentinel::save();

?>
