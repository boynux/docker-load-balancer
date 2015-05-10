#!/bin/bash

cleanup() {
    echo "Removing routes ..."
    sudo ip route del $VIRTUAL_IP via $IP

    echo "Cleaning up docker images ..."
    sudo docker rm -f $ID1
    sudo docker rm -f $ID2
    sudo docker rm -f $ID3

    sudo docker rm -f $ID
    exit
}

VIRTUAL_IP=$1

echo "Creating docker images ..."

ID1=$(./nginx/run.sh $VIRTUAL_IP)
ID2=$(./nginx/run.sh $VIRTUAL_IP)
ID3=$(./nginx/run.sh $VIRTUAL_IP)

IP1=$(sudo docker inspect -f '{{.NetworkSettings.IPAddress}}' $ID1)
IP2=$(sudo docker inspect -f '{{.NetworkSettings.IPAddress}}' $ID2)
IP3=$(sudo docker inspect -f '{{.NetworkSettings.IPAddress}}' $ID3)

ID=$(./ipvs/run.sh "$VIRTUAL_IP" "$IP1 $IP2 $IP3")
IP=$(sudo docker inspect -f '{{.NetworkSettings.IPAddress}}' $ID)

echo "Adding route ..."
sudo ip route add $VIRTUAL_IP via $IP

echo "Press ctrl-c to cancel"
trap cleanup SIGINT

while true
do
    sleep 1
done

