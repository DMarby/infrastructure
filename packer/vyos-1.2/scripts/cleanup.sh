#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

# Clean up
sudo apt-get autoclean
sudo apt-get clean

# Removing leftover leases and persistent rules
sudo rm -f /var/lib/dhcp3/*

# Removing apt caches
sudo rm -rf /var/cache/apt/*

# Adding a 2 sec delay to the interface up, to make the dhclient happy
echo "pre-up sleep 2" | sudo tee -a /etc/network/interfaces

# Removing hw-id
delete interfaces ethernet eth0 hw-id
commit
save
