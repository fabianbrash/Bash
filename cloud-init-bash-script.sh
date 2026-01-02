#!/bin/bash


#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# --- 1. System Update ---
# Equivalent to: package_upgrade: true
apt-get update
apt-get upgrade -y

# --- 2. Package Installation ---
# Equivalent to: packages: [curl, wget, bzip2, policycoreutils]
apt-get install -y curl wget bzip2 policycoreutils screenfetch tree s-tui

# --- 3. User Creation and Configuration (User 'ubuntu') ---

USER_NAME="ubuntu"
USER_PASS="my_favorite_password"
SSH_KEYS=(
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVCsjZQUH0XerR9k+Fzu0Uex5NmLqUWVflF7DQ+c0Yz Fabian.B@Fabian.fios-router.home"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDurFwCUbO48/eMNCIA0ZOA28UHRUTaLy0b0xWOM8Bdeh8alsRg83gAKOhQMllt6O1w7BDBo9MizGDG+O/H4lu/9C+7x8mBF7ACxU+BUtWXBMWyUeiBuPopdTTdIm2LsGxfPtL4K9t+QIfxpwOcgiGQDYE7jlu8Ajqw2KsZyXyIpGjngbn08kaGRaUPsZTtQgojXeFXxFkIMYZ1QKyD43gYUOP/XKfPXkW6o4StRAQmVTSiRF4EE7D0bMFVciuygV1PLlsBUhhoH0vscJkumMCMKTX/FOuRUx5cokwX6/zMpuRbsVggl/+D5/3DbnIL72ESDaMKf+DLxRKOmV1RRwQ8gBNYiqZi8WJLH2dwDhxMuRp1pW1cGvKdMR7bAc5WKsn+bZJscJp74LgpSCwK0JH/CeypVZMTvGZFHA3x9l1SK264+Tf8C3re3ciCFVaOdqCse0yck7pBLnPYPMErIoC9zn9fQYILHU5+AZL/OKENXMvjaisX4dChPVB6qHSw1V61CZqFH0W6TcJnhkKULGwJsF9QAIv9uYD/ekSd6/+VIQAbYDFKummqXA1AWSD1qcrzjxxXI1nLMQhnNlJd/0tULOeVw8fA2BAwrULLURlOgg/VdY1ytikmQxKasleK781+mj4On7HVj3rDNusvu7Qm4slNNsZUlTEFw9QMf57GCw== fb-skytech-1"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVXcMbIRtYZ9gB6ZYOIkbMKnLDY790rE07KQJJqq77 frb79@fb-skytech-1"
)

# Create the user with specified shell and add to sudoers (NOPASSWD)
# Equivalent to: sudo: ALL=(ALL) NOPASSWD:ALL
useradd -m -s /bin/bash "$USER_NAME"
usermod -aG sudo "$USER_NAME"
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USER_NAME"

# Set the plain text password (Equivalent to: plain_text_passwd and lock_passwd: false)
# NOTE: This is inherently insecure as it's visible in the script.
echo "$USER_NAME:$USER_PASS" | chpasswd

# Inject SSH keys
# Equivalent to: ssh-authorized-keys
HOME_DIR="/home/$USER_NAME"
SSH_DIR="$HOME_DIR/.ssh"
AUTH_FILE="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

for key in "${SSH_KEYS[@]}"; do
    echo "$key" >> "$AUTH_FILE"
done

chmod 600 "$AUTH_FILE"
chown -R "$USER_NAME":"$USER_NAME" "$SSH_DIR"

# --- 4. Enable SSH Password Authentication ---
# Equivalent to: ssh_pwauth: True
# This is usually done by editing the sshd_config file
if grep -q "PasswordAuthentication no" /etc/ssh/sshd_config; then
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
elif ! grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
fi

# Restart SSH service to apply changes
systemctl restart sshd

echo "Startup script execution complete."

### Install Viddy

wget -O viddy.tar.gz https://github.com/sachaos/viddy/releases/download/v1.3.0/viddy-v1.3.0-linux-x86_64.tar.gz && tar xvf viddy.tar.gz && mv viddy /usr/local/bin

### Install kdash

curl https://raw.githubusercontent.com/kdash-rs/kdash/main/deployment/getLatest.sh | bash


# Reboot the system

reboot now
