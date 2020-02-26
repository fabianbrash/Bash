#!/bin/bash

#REF:https://infiniteloop.io/vmware-template-ubuntu-18-04-3-lts/
echo Update system
apt update -y && apt upgrade -y
echo Stop rsyslog
service rsyslog stop
echo Empty log files
find /var/log/ -type f -exec cp /dev/null {} \;
echo Remove tmp files
rm -rf /tmp/*
rm -rf /var/tmp/*
echo Remove host SSH keys
rm -f /etc/ssh/ssh_host_*
echo Create /etc/rc.local to regenerate ssh host keys if needed
cat << 'EOL' > /etc/rc.local 
#!/bin/sh
if [ ! -e /etc/ssh/ssh_host_rsa_key ]; then
  dpkg-reconfigure openssh-server
  systemctl restart ssh
fi
exit 0
EOL
chmod +x /etc/rc.local
echo Clean apt
apt clean
echo Clean cloud-init logs
cloud-init clean --logs
echo Clear machine-id
cp /dev/null /etc/machine-id
echo Remove unwanted MOTD detail
chmod -x /etc/update-motd.d/10-help-text
chmod -x /etc/update-motd.d/50-motd-news
if [ ! -e vmwarefixran.log ]; then
  echo vmware customization fix https://kb.vmware.com/s/article/56409
  sed -i 's/^D \/tmp 1777 root root -/#D \/tmp 1777 root root -/' /usr/lib/tmpfiles.d/tmp.conf
  sed -i '/^\[Unit\]/a\After=dbus.service' /lib/systemd/system/open-vm-tools.service
  touch vmwarefixran.log
else
  echo vmware fix already ran
fi
echo Clear bash history
cp /dev/null ~/.bash_history && history -cw
echo shutdown
# uncomment if you want to shutdown immediately
#shutdown now
# you may want to run history -cw as your logged in account too
