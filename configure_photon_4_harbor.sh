#!/bin/bash

# Colors

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[TASK 1] checking for updates and patching system${NC}"
sleep 2
tdnf check-update && tdnf upgrade -y

echo -e "${GREEN}[TASK 2] Installing tar and unzip${NC}"
sleep 2
tdnf install -y tar unzip

echo -e "${GREEN}[TASK 3] Installing Docker-compose${NC}"
sleep 2
curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo -e "${GREEN}[TASK 4] Downloading Harbor online installer${NC}"
sleep 3
mkdir -p /root/harbor-files
mkdir -p /opt/vmware
cd /root/harbor-files
curl -LO https://github.com/goharbor/harbor/releases/download/v2.5.0/harbor-online-installer-v2.5.0.tgz
tar -xzvf harbor-online-installer-v2.5.0.tgz
cp -rp /root/harbor-files/harbor /opt/vmware/
cp -p /opt/vmware/harbor/harbor.yml.tmpl /opt/vmware/harbor/harbor.yml


echo -e "${GREEN}[TASK 5] Fixing network config issues${NC}"
sleep 3
cp -p /etc/systemd/network/99-dhcp-en.network /etc/systemd/network/99-dhcp-en.network.BAK
sed -i 's/DHCP=yes/DHCP=no/g' /etc/systemd/network/99-dhcp-en.network
mv /etc/systemd/network/99-static-en.network /etc/systemd/network/10-static-en.network

echo -e "${GREEN}[TASK 6] Permit root login over ssh"
sleep 3
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.ORIG
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config

echo -e "${GREEN}[TASK 7] Enabling Docker${NC}"
sleep 3
systemctl enable docker

echo -e "${GREEN}[TASK 8] Cleaning up${NC}"
sleep 2
rm -rf /root/harbor-files
sleep 3

echo -e "${GREEN}[TASK 9] REBOOTING...${NC}"
sleep 8
reboot now
