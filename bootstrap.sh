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

chmod a+w /etc/issue
true  > /etc/issue

#Create a rc.local to add ip to 
cat << EOF > /etc/rc.local
#!/bin/sh -e
# rc.local
# Create a small logo
printf "\n" >> /etc/issue
echo "${c4}${c5}  _ _ _            _____         _            " > /etc/issue
echo "${c4}${c5} | | | |___ ___   |_   _|___ ___| |_ ___ ___  " >> /etc/issue
echo "${c4}${c5} | | | | .'|   |    | | | -_|_ -|  _| -_|  _| " >> /etc/issue
echo "${c4}${c5} |_____|__,|_|_|    |_| |___|___|_| |___|_| " >> /etc/issue
echo " " >> /etc/issue
printf "Access the management interface using a browser on http://\\4{eth0}" >> /etc/issue
echo " " >> /etc/issue
EOF\

chmod +x /etc/rc.local

shutdown -r now

exit 0

