<?php
# Create a default admin user
include 'inc/global.inc.php';
include 'inc/classes/Sentinel.php';

Sentinel::init();
Sentinel::create();
if (array_key_exists('SYSLOG_USERNAME', $_ENV)){
        $username = $_ENV['SYSLOG_USERNAME'];
} else {
        $username = 'admin';
}
if (array_key_exists('SYSLOG_PASSWORD', $_ENV)){
        $password = $_ENV['SYSLOG_PASSWORD'];
} else {
        $password = 'SyslogP4ss';
}

echo "Creating user with credentials: $username:$password\n";
Sentinel::setAdmin($username,$password);
Sentinel::save();

?>
