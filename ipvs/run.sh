ID=$(sudo docker run -d --privileged -e VIRTUAL_IP="$1:80" -e REAL_SERVERS="$2" boynux:ipvs)
IP=$(sudo docker inspect -f '{{.NetworkSettings.IPAddress}}' $ID)
PID=$(docker inspect -f '{{.State.Pid}}' $ID)
VNET="vnet${ID:0:8}"

sudo mkdir -p /var/run/netns
sudo ln -s /proc/$PID/ns/net /var/run/netns/$PID

sudo ip link add $VNET type dummy
sudo ip link set $VNET netns $PID

sudo ip netns exec $PID ip link set dev $VNET name eth1
sudo ip netns exec $PID ip link set eth1 up
sudo ip netns exec $PID ip addr add "$1/32" dev eth1
sudo ip netns exec $PID ip rout add "$1" dev eth1 scope link

echo $ID
