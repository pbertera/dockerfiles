<?php
# Create a default admin user
include 'inc/global.inc.php';
include 'inc/classes/Sentinel.php';

Sentinel::init();
Sentinel::create();
$username = $_ENV['SYSLOG_USERNAME'];
$password = $_ENV['SYSLOG_PASSWORD'];

echo "Creating user with credentials: $username:$password\n";

Sentinel::setAdmin($username,$password);
Sentinel::save();

?>
