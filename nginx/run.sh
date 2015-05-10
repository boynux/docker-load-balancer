ID=$(sudo docker run -d  boynux:nginx)
PID=$(docker inspect -f '{{.State.Pid}}' $ID)
VNET="vnet${ID:0:8}"
IP="$1"

sudo mkdir -p /var/run/netns
sudo ln -s /proc/$PID/ns/net /var/run/netns/$PID

sudo ip link add $VNET type dummy
sudo ip link set $VNET netns $PID

sudo ip netns exec $PID ip link set dev $VNET name eth1
sudo ip netns exec $PID ip link set eth1 up
sudo ip netns exec $PID ip addr add "$IP/32" dev eth1
sudo ip netns exec $PID ip rout add "$IP" dev eth1 scope link

echo $ID

