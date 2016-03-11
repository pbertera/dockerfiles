#!/bin/bash

if [ "$1" == "server" ]; then
    exec netserver $@
elif [ "$1" == "client" ]; then
    exec netperf $@
else
    echo "ERROR: You have to specify the mode: $0 <server|client>"
    exit -1
fi
