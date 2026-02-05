#!/bin/bash

# Exit on any error
set -e

echo "--- 1. Updating and Installing Packages ---"
# Install EPEL repository (needed for fail2ban and other community tools)
dnf install -y epel-release
dnf update -y
dnf install -y curl wget tar vim fail2ban firewalld dnf-automatic

# Start and enable services
systemctl enable --now firewalld
systemctl enable --now fail2ban

#---

echo "--- 2. Creating User: alma1 ---"
# Changed user to alma1 to match your password lock command
NEW_USER="alma1"

if ! id "$NEW_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$NEW_USER"
fi

# Set up Passwordless Sudo
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$NEW_USER-user

# Disable password login for the user
passwd -l "$NEW_USER"

#---

echo "--- 3. Configuring SSH Keys ---"
USER_HOME="/home/$NEW_USER"
SSH_DIR="$USER_HOME/.ssh"

mkdir -p "$SSH_DIR"

# Add the keys to authorized_keys
cat <<EOF > "$SSH_DIR/authorized_keys"
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVCsjZQUH0XerR9k+Fzu0Uex5NmLqUWVflF7DQ+c0Yz Fabian.B@Fabian.fios-router.home
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDurFwCUbO48/eMNCIA0ZOA28UHRUTaLy0b0xWOM8Bdeh8alsRg83gAKOhQMllt6O1w7BDBo9MizGDG+O/H4lu/9C+7x8mBF7ACxU+BUtWXBMWyUeiBuPopdTTdIm2LsGxfPtL4K9t+QIfxpwOcgiGQDYE7jlu8Ajqw2KsZyXyIpGjngbn08kaGRaUPsZTtQgojXeFXxFkIMYZ1QKyD43gYUOP/XKfPXkW6o4StRAQmVTSiRF4EE7D0bMFVciuygV1PLlsBUhhoH0vscJkumMCMKTX/FOuRUx5cokwX6/zMpuRbsVggl/+D5/3DbXIL72ESDaMKf+DLxRKOmV1RRwQ8gBNYiqZi8WJLH2dwDhxMuRp1pW1cGvKdMR7bAc5WKsn+bZJscJp74LgpSCwK0JH/CeypVZMTvGZFHA3x9l1SK264+Tf8C3re3ciCFVaOdqCse0yck7pBLnPYPMErIoC9zn9fQYILHU5+AZL/OKENXMvjaisX4dChPVB6qHSw1V61CZqFH0W6TcJnhkKULGwJsF9QAIv9uYD/ekSd6/+VIQAbYDFKummqXA1AWSD1qcrzjxxXI1nLMQhnNlJd/0tULOeVw8fA2BAwrULLURlOgg/VdY1ytikmQxKasleK781+mj4On7HVj3rDNusvu7Qm4slNNsZUlTEFw9QMf57GCw== fb-skytech-1
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVXcMbIRtYZ9gB6ZYOIkbMKnLDY790rE07KQJJqq77 frb79@fb-skytech-1
EOF

# Set correct permissions
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR/authorized_keys"
chown -R "$NEW_USER":"$NEW_USER" "$SSH_DIR"

#---

echo "--- 4. Hardening SSH Configuration ---"
# AlmaLinux/RHEL usually has these set, but this ensures they are locked down
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config

systemctl restart sshd

#---

#echo "--- 5. Configuring Firewall (firewalld) ---"
# AlmaLinux uses firewalld instead of UFW
#firewall-cmd --permanent --add-service=ssh
#firewall-cmd --set-default-zone=drop
#firewall-cmd --reload

echo "--- 5. Configuring Firewall (Hardware-Safe) ---"
systemctl enable --now firewalld

# 1. Get the active interface (like eno1)
ACTIVE_IFACE=$(nmcli -t -f DEVICE,STATE device | grep ":connected" | cut -d: -f1 | head -n1)

# 2. Add SSH to the public zone
firewall-cmd --permanent --zone=public --add-service=ssh

# 3. Assign the active interface to the public zone
if [ -n "$ACTIVE_IFACE" ]; then
    firewall-cmd --permanent --zone=public --add-interface="$ACTIVE_IFACE"
fi

# 4. Set public as default and reload
firewall-cmd --set-default-zone=public
firewall-cmd --reload

#---

echo "--- 6. Installing Custom Tools (viddy) ---"
cd /tmp
wget -O viddy.tar.gz https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-linux-x86_64.tar.gz
tar xvf viddy.tar.gz
mv viddy /usr/local/bin/
rm viddy.tar.gz

echo "--- Setup Complete! Rebooting... ---"
sleep 2
reboot
