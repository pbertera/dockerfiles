#!/bin/bash

set -e

status () {
  echo "---> ${@}" >&2
}

if [[ -n "$AST_OVERRIDE_CONF" ]]; then
    status "Overriding the configuration!"
    rm -f /var/lib/asterisk/docker_bootstrapped
fi

if [ ! -f /var/lib/asterisk/docker_bootstrapped ]; then
    status "Configuring Asterisk for first run"
    if [[ -n "$AST_RTP_PORT_START" ]]; then
        status "Configuring RTP port start to ${AST_RTP_PORT_START}"
        sed -i -e "s/rtpstart=.*/rtpstart=${AST_RTP_PORT_START}/" /etc/asterisk/rtp.conf    
    fi
    if [[ -n "$AST_RTP_PORT_END" ]]; then
        status "Configuring RTP port end to ${AST_RTP_PORT_END}"
        sed -i -e "s/rtpend=.*/rtpstart=${AST_RTP_PORT_START}/" /etc/asterisk/rtp.conf    
    fi
    touch /var/lib/asterisk/docker_bootstrapped
else
    status "found already-configured asterisk"
fi

/usr/sbin/asterisk -f $@
