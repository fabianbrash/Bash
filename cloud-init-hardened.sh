#!/bin/bash

# Exit on any error
set -e

echo "--- 1. Updating and Installing Packages ---"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y curl wget fail2ban ufw unattended-upgrades

---

echo "--- 2. Creating User: ubuntu2 ---"
# Create the user if they don't exist
if ! id "ubuntu2" &>/dev/null; then
    useradd -m -s /bin/bash ubuntu2
fi

# Set up Passwordless Sudo
echo "ubuntu2 ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-ubuntu2-user

# Disable password login for the user
passwd -l ubuntu2

---

echo "--- 3. Configuring SSH Keys ---"
USER_HOME="/home/ubuntu2"
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
chown -R ubuntu2:ubuntu2 "$SSH_DIR"

---

echo "--- 4. Hardening SSH Configuration ---"
# System-wide: Disable password auth, disable root login, set max tries
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config

# Restart SSH to apply changes
systemctl restart ssh

---

echo "--- 5. Configuring Firewall (UFW) ---"
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

---

echo "--- 6. Installing Custom Tools (viddy) ---"
cd /tmp
wget -O viddy.tar.gz https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-linux-x86_64.tar.gz
tar xvf viddy.tar.gz
mv viddy /usr/local/bin/
rm viddy.tar.gz

echo "--- Setup Complete! ---"

sudo reboot now
