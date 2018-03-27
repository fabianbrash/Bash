#!/bin/bash

#Give a warning about running as sudo and make certain all args are inputed
#I need to programmatically do this in the future
echo "##########################################################################"
echo "Please make certain you are running this script with sudo and that all args have been entered on the cli"
echo "You will have 10 seconds to end this script with CTRL+C"
echo "##########################################################################"

sleep 10

#Create a new connection for production and take 2 arguments(IP and Gateway)
#nmcli con add type ethernet con-name ens192-prod ifname ens192 ip4 $1/24 gw4 $2 ipv4.dns "10.10.99.161"
#nmcli con up ens192-prod
#sleep 5

##Set a hostname for the system, this is argument 3
#hostnamectl set-hostname $3 --static
#systemctl restart systemd-hostnamed

##Let's generate a new random machine ID this is applicable to centOS/RHEL 7.1 and above
#rm -f /etc/machine-id
#systemd-machine-id-setup


##TODO

###Let's create some temp storage
mkdir /home/saprime/automated_temp
cd /home/saprime/automated_temp && curl -LO http://10.10.96.248/sshkeys/keys.pub

####Let's setup ssh keys, we know there are 2 users on the system
#Replace user with the user you want to apply settings to
if [ ! -d /home/saprime/.ssh ]
 then
     mkdir /home/saprime/.ssh
fi

if [ ! -d /root/.ssh ]
 then
    mkdir /root/.ssh
fi

##Let's create our file and then inject with current keys
touch /home/saprime/.ssh/authorized_keys
cat /home/saprime/automated_temp/keys.pub >> /home/saprime/.ssh/authorized_keys

#Let's copy keys for root as well
touch /root/.ssh/authorized_keys
cat /home/saprime/automated_temp/keys.pub >> /root/.ssh/authorized_keys

##We have to do this because we will be running as root
chown -R saprime:saprime /home/saprime/.ssh

###set permission on authorized_keys file
chmod 700 /home/saprime/.ssh
chmod 600 /home/saprime/.ssh/authorized_keys

#Do for root as well
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys


###Cleanup time
rm -rf /home/saprime/automated_temp
