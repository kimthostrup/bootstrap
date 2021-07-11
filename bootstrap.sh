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

# Configure DNS
unlink /etc/resolv.conf
touch /etc/resolv.conf
echo nameserver 8.8.8.8 >> /etc/resolv.conf

dpkg -P cloud-init
rm -fr /etc/cloud/
systemctl disable --now systemd-resolved

# Enable ipv4 routing 
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf

# Install ttyd
apt-get install build-essential cmake git libjson-c-dev libwebsockets-dev -y
git clone https://github.com/tsl0922/ttyd.git
cd ttyd && mkdir build && cd build
cmake ..
make && sudo make install
cd

#Changing the issues file
rm -rf /etc/issue*
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/issues -P /etc/
cp /etc/issues /etc/issues.net
chown root:root /etc/issue*

#Install the nessesary python dependencies
apt install nginx python3-pip gunicorn -y

echo "Installing python prerequisites"
#pip3 install -U Flask netifaces psutil sh
sudo -H -u wan-admin pip3 install -U Flask netifaces psutil sh

# Add the nginx site config
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/wan-tester -P /etc/nginx/sites-enabled/

# Pull the primary source
cd /var/
#echo "Doing a git pull"
#git config --global credential.helper store
git clone https://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:x-oauth-basic@github.com/kimthostrup/wan-tester.git

#Setting ownership and permission
chown -R wan-admin:staff /var/wan-tester
chmod -R ug+rwx /var/wan-tester

#Download the service file
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/kimthostrup/bootstrap/main/wan-tester.service -P /etc/systemd/system/
systemctl enable wan-tester
systemctl start wan-tester

#echo "Restarting Wan Tester"
reboot

exit 0
