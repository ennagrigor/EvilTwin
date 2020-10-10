#!/bin/bash

echo "Configuring dhcp settings"

cat > dnsmasq.conf <<EOF
interface=at0
dhcp-range=10.0.0.10,10.0.0.250,12h
dhcp-option=3,10.0.0.1
dhcp-option=6,10.0.0.1
server=8.8.8.8
log-queries
log-dhcp
listen-address=127.0.0.1
EOF

{ xterm -e sudo dnsmasq -C dnsmasq.conf -d; } &

echo "Finished configuring dhcp settings"