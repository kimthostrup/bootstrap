#!/bin/bash

MOTD_LOC=/etc/motd

sudo apt update
sudo apt upgrade -y

echo "adding wan-admin to sudoers file"
sudo cp /etc/sudoers{,.back$(date +%s)}
echo "wan-admin ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

echo "Disabling netplan and changing interface names"
sudo apt install ifupdown net-tools
sudo mv /etc/default/grub /etc/default/grub.org
sudo wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/grub -P /etc/default/
sudo update-grub


echo "Changing networking files"
sudo cp /etc/network/interfaces{,.back$(date +%s)}
sudo wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/interfaces -P /etc/network/

LOGO="_ _ _            _____         _\           
| | | |___ ___   |_   _|___ ___| |_ ___ ___\ 
| | | | .'|   |    | | | -_|_ -|  _| -_|  _|\
|_____|__,|_|_|    |_| |___|___|_| |___|_|\  
                                            

══════════════════════════════════════════════════\
TYPE: $1\
OS: $(lsb_release -d | cut -f2-)\
IP: $(hostname -I)\
INIT: $(date +"%Y-%m-%dT%H:%M:%SZ")\
══════════════════════════════════════════════════\
Notice: This server is for authorized use only.\
By continuing, you agree to the Security policy.\
══════════════════════════════════════════════════"

sudo echo $LOGO > $MOTD_LOC

echo "Rebooting....."
sudo shutdown -r now

exit 0

