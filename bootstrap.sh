#!/bin/bash

sudo apt update
sudp apt upgrade -y

echo "adding wan-admin to sudoers file"
sudo cp /etc/sudoers{,.back$(date +%s)}
echo "wan-admin ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

echo "Disabling netplan and changing interface names"
sudo apt install ifupdown net-tools
sudo mv /etc/default/grub /etc/default/grub.org
sudo wget --no-check-certificate --content-disposition https://gist.githubusercontent.com/kimthostrup/900cdfec4c45932bb3270242904b2e9d/raw/b61dd82a84759a2462113a258f2a7a4a2fc51c49/grub -P /etc/default/
sudo update-grub

echo "Rebooting....."
