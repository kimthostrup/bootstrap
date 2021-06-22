#!/bin/bash

sudo apt update
sudp apt upgrade -y

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

echo "Rebooting....."
sudo shutdown -r now

