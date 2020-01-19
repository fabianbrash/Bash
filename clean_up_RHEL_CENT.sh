#!/bin/bash

#REF:http://everything-virtual.com/2016/05/06/creating-a-centos-7-2-vmware-gold-template/
systemctl stop rsyslog
service auditd stop

rpm -q kernel
sleep 10
package-cleanup --oldkernels --count=1  ##Requires yum-utils
yum clean all
su -
rm -rf /var/log/*-???????? /var/log/*.gz
rm -rf /var/log/dmesg.old
rm -rf /var/log/anaconda
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/grubby

#Next we are going to remove the old hardware rules and remove the UUID from the ifcfg scripts.
rm -f /etc/udev/rules.d/70*

##The below gave me issues so it's simply best to just blow it away and re-create on initial boot
#sed –i”.bak” ‘/UUID/d’ /etc/sysconfig/network-scripts/ifcfg-ens192 #The device is specific please set appropriately
rm -f /etc/sysconfig/network-scripts/ifcfg-ens192 ##again the name is specific please check first

#We are then going to remove SSH host keys so that each new VM
rm -f /etc/ssh/*key*

#We are going to remove the root users shell history
rm -f ~root/.bash_history #Remember to remove for each user on the system
unset HISTFILE

#remove machine id so we have a unique ID when VM boots up
rm -f /etc/machine-id

#Finally we are going remove root users SSH history and then shutdown for template creation
rm -rf ~root/.ssh/ #Do this for each user
echo "Finished now you can run history -c and then sys-unconfig"
#############Run the below 2 lines manually##############################################
##history –c
##sys-unconfig
