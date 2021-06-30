#!/bin/bash

printf "Bootstrapping the Wan Tester"
output=/dev/null

apt update
apt upgrade -y

# adding wan-admin to sudoers file
cp /etc/sudoers{,.back$(date +%s)}
echo "wan-admin ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

#Disabling netplan and changing interface names
apt install ifupdown net-tools
mv /etc/default/grub /etc/default/grub.org
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/grub -P /etc/default/
update-grub

# Remove all the spam from login page
rm -rf /etc/update-motd.d/10-help-text
rm -rf /etc/update-motd.d/50-motd-news
rm -rf /etc/update-motd.d/50-landscape-sysinfo
rm -rf /etc/update-motd.d/88-esm-announce
rm -rf /etc/update-motd.d/91-contract-ua-esm-status
rm -rf /etc/update-motd.d/91-release-upgrade
rm -rf /etc/update-motd.d/92-unattended-upgrades
rm -rf /etc/update-motd.d/95-hwe-eol
rm -rf /etc/update-motd.d/97-overlayroot

#Changing networking files
rm /etc/network/interfaces
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/interfaces -P /etc/network/

#Clear our the default issues file
rm -rf /etc/issue
#Download the issues file
wget --no-check-certificate --content-disposition   -P /etc/

#Install the nessesary python dependencies
apt install python3-pip -y
apt install nginx -y
pip3 install -U Flask
pip3 install -U netifaces
pip3 install -U psutil

# Pull the primary source
mkdir /var/wan-tester
cd /var/wan-tester
git reset --hard
#echo "Doing a git pull"
#git pull http://wantester.thostrup.dk



# Configure DNS
unlink /etc/resolv.conf
touch /etc/resolv.conf
echo nameserver 8.8.8.8 >> /etc/resolv.conf

dpkg -P cloud-init
rm -fr /etc/cloud/
systemctl disable --now systemd-resolved

# Enable ipv4 routing 
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

#echo "Setting ownership and permission"
sudo chown -R wan-admin:staff /var/wan-tester
sudo chmod -R ug+rwx /var/wan-tester

# Install ttyd
apt-get install build-essential cmake git libjson-c-dev libwebsockets-dev


#echo "Restarting Wan Tester"
shutdown -r now

exit 0
