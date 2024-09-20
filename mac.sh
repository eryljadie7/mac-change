#!/bin/bash

# Set the interface name and prompt for line number
iface=wlan0
read -p "Enter the line number from mac.txt: " lineno

# Check if the line number is valid
if [[ ! "$lineno" =~ ^[0-9]+$ ]]; then
    echo "Invalid line number. Please enter a positive integer."
    exit 1
fi

# Read the specified line from mac.txt
newmac=$(awk -v line="$lineno" 'NR == line {print; exit}' mac.txt)

# Check if the new MAC address is valid
if [[ ! "$newmac" =~ ^[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}$ ]]; then
    echo "Invalid MAC address format. Please ensure it's in the format XX:XX:XX:XX:XX:XX"
    exit 1
fi

# Bring down the interface, change the MAC address, and bring it back up
sudo ifconfig $iface down
macchanger --mac $newmac $iface
sudo ifconfig $iface up
