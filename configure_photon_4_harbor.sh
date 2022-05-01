#!/bin/bash

# Patch our system

echo "[CHECKING FOR UPDATES AND PATCHING SYSTEM]"
sleep 10
tdnf check-update && tdnf upgrade -y

echo "[INSTALLING TAR AND UNZIP]"
sleep 10
tdnf install -y tar unzip

echo "[DOWNLOAD AND INSTALLING DOCKER-COMPOSE]"
sleep 10
curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "[DOWNLOADING HARBOR ONLINE INSTALLER]"
sleep 10
mkdir -p /root/harbor-files
mkdir -p /opt/vmware
cd /root/harbor-files
curl -LO https://github.com/goharbor/harbor/releases/download/v2.5.0/harbor-online-installer-v2.5.0.tgz
tar -xzvf harbor-online-installer-v2.5.0.tgz
cp -p harbor /opt/vmware/


echo "[FIXING NETWORK CONFIG ISSUE]"
sleep 10
cp -p /etc/systemd/network/99-dhcp-en.network /etc/systemd/network/99-dhcp-en.network.BAK
sed -i 's/DHCP=yes/DHCP=no/g' /etc/systemd/network/99-dhcp-en.network
mv /etc/systemd/network/99-static-en.network /etc/systemd/network/10-static-en.network

echo "[PERMIT ROOT LOGIN OVER SSH]"
sleep 10
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.ORIG
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config

echo "[ENABLING DOCKER]"
sleep 10
systemctl enable docker

echo "[REBOOTING...]"
sleep 15
reboot now
