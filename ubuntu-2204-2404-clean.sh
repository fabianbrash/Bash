#!/bin/bash

## AM I root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Try: sudo $0"
   exit 1
fi
# --- 1. System Updates & Required Packages ---
# Added cloud-guest-utils so the partition can auto-expand on first boot
apt update && apt -y upgrade
apt install -y open-vm-tools bzip2 cloud-guest-utils
apt -y autoremove
apt clean

# --- 2. User Cleanup ---
# Removes the default 'ubuntu' user if it exists (common in cloud images)
if id "ubuntu" &>/dev/null; then
    userdel -r -f ubuntu
fi

# --- 3. Networking & Hostname ---
# Clear the hostname so it can be set by vSphere/Cloud-init
truncate -s 0 /etc/hostname
hostnamectl set-hostname localhost

# Remove all existing Netplan configs to prevent IP conflicts
rm -f /etc/netplan/*.yaml

# --- 4. Machine ID (Critical for Unique IPs) ---
# Truncating to 0 length is safer than deleting; it triggers a regen on boot
truncate -s 0 /etc/machine-id
if [ -f /var/lib/dbus/machine-id ]; then
    rm /var/lib/dbus/machine-id
    ln -s /etc/machine-id /var/lib/dbus/machine-id
fi

# --- 5. Cloud-Init Customization ---
echo '> Cleaning cloud-init'

# Remove installer-specific leftovers
rm -rf /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
rm -rf /etc/cloud/cloud.cfg.d/99-installer.cfg
rm -rf /etc/cloud/cloud.cfg.d/curtin-preserve-sources.cfg

# Set the datasource priority for VMware environments
echo 'datasource_list: [ VMware, NoCloud, ConfigDrive ]' | tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg

# Ensure the disk expands to fill the vSphere provisioned size
cat <<EOF | tee /etc/cloud/cloud.cfg.d/95_growpart.cfg
growpart:
  mode: auto
  devices: ['/']
  ignore_growroot_disabled: false
resize_rootfs: true
EOF

# Use the official clean command to reset cloud-init status
cloud-init clean --logs

# --- 6. Security & Logs ---
# Disable root password
passwd -dl root

# Clear logs and shell history
find /var/log -type f -exec truncate -s 0 {} \;
find /root /home -name ".bash_history" -exec truncate -s 0 {} \;
history -c

# --- 7. Finalize ---
echo 'Cleanup complete. Shutting down...'
shutdown -h now
