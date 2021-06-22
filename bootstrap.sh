#!/bin/bash

apt update
apt upgrade -y

echo "adding wan-admin to sudoers file"
cp /etc/sudoers{,.back$(date +%s)}
echo "wan-admin ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

echo "Disabling netplan and changing interface names"
apt install ifupdown net-tools
mv /etc/default/grub /etc/default/grub.org
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/grub -P /etc/default/
update-grub

rm -rf /etc/update-motd.d/95-hwe-eol
rm -rf /etc/update-motd.d/88-esm-announce
rm -rf /etc/update-motd.d/91-contract-ua-esm-status
rm -rf /etc/update-motd.d/91-release-upgrade
rm -rf /etc/update-motd.d/50-motd-news

echo "Changing networking files"
rm /etc/network/interfaces
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/interfaces -P /etc/network/

ip_address=`ip -4 addr | grep -E 'eth0' | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`

printf "\n" >> /etc/issue
echo "${c4}${c5}  _ _ _            _____         _            " > /etc/issue
echo "${c4}${c5} | | | |___ ___   |_   _|___ ___| |_ ___ ___  " >> /etc/issue
echo "${c4}${c5} | | | | .'|   |    | | | -_|_ -|  _| -_|  _| " >> /etc/issue
echo "${c4}${c5} |_____|__,|_|_|    |_| |___|___|_| |___|_| " >> /etc/issue
printf "\n" >> /etc/issue


echo "Rebooting....."
sudo shutdown -r now

exit 0

