#!/bin/bash

echo "Adding $VIRTUAL_IP to service ..."
ipvsadm -A -t $VIRTUAL_IP -s wlc

for rs in $REAL_SERVERS
do
    echo "Adding real server $rs ..."
    ipvsadm -a -t $VIRTUAL_IP -r $rs -g
done

while true
do
    sleep 1
done 
