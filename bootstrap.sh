#!/bin/bash

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

sudo rm -rf /etc/update-motd.d/95-hwe-eol
sudo rm -rf /etc/update-motd.d/88-esm-announce
sudo rm -rf /etc/update-motd.d/91-contract-ua-esm-status
sudo rm -rf /etc/update-motd.d/91-release-upgrade
sudo rm -rf /etc/update-motd.d/50-motd-news

echo "Changing networking files"
sudo rm /etc/network/interfaces
sudo wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/interfaces -P /etc/network/

ip_address=`ip -4 addr | grep -E 'eth|ens' | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
printf "\n" >> /etc/issue
echo "${c4}${c5}  _ _ _            _____         _            " > /etc/issue
echo "${c4}${c5} | | | |___ ___   |_   _|___ ___| |_ ___ ___  " >> /etc/issue
echo "${c4}${c5} | | | | .'|   |    | | | -_|_ -|  _| -_|  _| " >> /etc/issue
echo "${c4}${c5} |_____|__,|_|_|    |_| |___|___|_| |___|_| " >> /etc/issue
printf "\n" >> /etc/issue


echo "Rebooting....."
sudo shutdown -r now

exit 0

