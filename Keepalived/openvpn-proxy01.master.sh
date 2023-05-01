#!/usr/bin/env bash

state=$3
ip='YOUR MASTER VIP'
mac=`ip link show eth0 | awk '/ether/ {print $2}'`
iface_id=`curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/"$mac"/interface-id`

case "$state" in
    "MASTER")
    		ec2-assign-private-ip-addresses \
                	--region eu-central-1 \
                        --aws-access-key 'YOUR ACCESS KEY' \
                        --aws-secret-key 'YOUR SECRET KEY' \
                        --network-interface "$iface_id" \
                        --secondary-private-ip-address "$ip" \
                        --allow-reassignment && ip addr add dev eth0 "$ip" label eth0:1
                ;;
    "BACKUP")
                ip addr del dev eth0 "$ip"/32
                ;;
    "FAULT")
                ip addr del dev eth0 "$ip"/32
                ;;
     *)
                ;;
esac
