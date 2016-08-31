#!/bin/sh

if [ "$1" == "help" ]; then
    echo "This container can be configured trough the following env. variables:"
    echo 
    echo "* LIGHTTPD_PROXY: if set lighttpd is configured in Proxy mode, the following env. variables are required:"
    echo "  * LIGHTTPD_PROXY_HOST: the host that you want to proxy"
    echo "  * LIGHTTPD_PROXY_PORT: the port of the proxied host"
    echo "  * LIGHTTPD_PORT: the listeing port"
    echo
    echo "if LIGHTTPD_PROXY isn't defined lighttpd is configred to serve the /var/www folder."
    echo "You can also define the variable LIGHTTPD_THROTTLE representing the max bandwitdh expressed in KB"
    exit
fi

mkfifo -m 600 /tmp/logpipe
cat <> /tmp/logpipe 1>&2 &




if [ "$LIGHTTPD_PROXY" != "" ]; then
    
    echo "===== Running in Proxy mode: ====="
    echo "  LIGHTTPD_PROXY_HOST=${LIGHTTPD_PROXY_HOST}"
    echo "  LIGHTTPD_PROXY_PORT=${LIGHTTPD_PROXY_PORT}"
    echo "  LIGHTTPD_PORT=${LIGHTTPD_PORT}"

    cat << EOF > /etc/lighttpd/lighttpd.conf
server.document-root = "/dev/null"
server.modules = ("mod_proxy")
server.errorlog = "/tmp/logpipe"

server.port = env.LIGHTTPD_PORT
proxy.server  = ( "" => (( "host" => env.LIGHTTPD_PROXY_HOST, "port" => env.LIGHTTPD_PROXY_PORT )))
EOF
else
    echo "===== Running in server mode: ====="
    echo "  LIGHTTPD_PORT=${LIGHTTPD_PORT}"

    cat << EOF > /etc/lighttpd/lighttpd.conf
server.modules = (
    "mod_access",
    "mod_accesslog"
)

include "/etc/lighttpd/mime-types.conf"
server.document-root = "/var/www"
server.indexfiles    = ("index.php", "index.html",
                        "index.htm", "default.htm")
server.follow-symlink = "enable"
server.port = env.LIGHTTPD_PORT

accesslog.filename = "/tmp/logpipe"
server.errorlog = "/tmp/logpipe"
EOF
fi

if [ "$LIGHTTPD_THROTTLE" != "" ]; then

    echo "  LIGHTTPD_THROTTLE=${LIGHTTPD_THROTTLE}"
    echo "server.kbytes-per-second = env.LIGHTTPD_THROTTLE" >> /etc/lighttpd/lighttpd.conf
fi

lighttpd -D -f /etc/lighttpd/lighttpd.conf
