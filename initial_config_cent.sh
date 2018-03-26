#!/bin/bash

#Give a warning about running as sudo and make certain all args are inputed
#I need to programmatically do this in the future
echo "##########################################################################"
echo "Please make certain you are running this script with sudo and that all args have been entered on the cli"
echo "You will have 10 seconds to end this script with CTRL+C"
echo"##########################################################################"

sleep 10

#Create a new connection for production and take 2 arguments(IP and Gateway)
nmcli con add type ethernet con-name ens192-prod ifname ens192 ip4 $1/24 gw4 $2 ipv4.dns "8.8.8.8"
nmcli con up ens192-prod
sleep 5

##Set a hostname for the system, this is argument 3
hostnamectl set-hostname $3 --static
systemctl restart systemd-hostnamed

##Let's generate a new random machine ID this is applicable to centOS/RHEL 7.1 and above
rm -f /etc/machine-id
systemd-machine-id-setup


##TODO
####Let's setup ssh keys, we know there are 2 users on the system
#Replace user with the user you want to apply settings to
if [ ! -d /home/user/.ssh ]
 then
     mkdir /home/user/.ssh
fi

touch /home/user/.ssh/autherized_keys

##We have to do this because we will be running as root
chown -R user:user /home/user/.ssh

cd /home/user && curl -LO http://serverIp/key.pub

cat /home/user/key.pub >> /home/user/.ssh/authorized_keys

###set permission on authorized_keys file
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys
