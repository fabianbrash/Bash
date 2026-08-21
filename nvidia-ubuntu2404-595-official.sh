#!/bin/bash
set -e

DRIVER_VERSION="595"

echo "==> Blacklisting nouveau..."
cat <<EOF > /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF
update-initramfs -u

echo "==> Updating package lists..."
apt-get update

echo "==> Checking running kernel vs installed headers..."
RUNNING_KERNEL=$(uname -r)
echo "Running kernel: ${RUNNING_KERNEL}"

if [ ! -d "/lib/modules/${RUNNING_KERNEL}/build" ]; then
  echo "==> Headers for running kernel not found. Installing linux-headers-${RUNNING_KERNEL}..."
  apt-get install -y linux-headers-${RUNNING_KERNEL}
else
  echo "==> Headers for running kernel already present."
fi

echo "==> Installing build dependencies..."
apt-get install -y build-essential dkms

echo "==> Installing NVIDIA server driver (headless, with DKMS)..."
apt-get install -y nvidia-headless-${DRIVER_VERSION}-server

echo "==> Installing nvidia-smi and utilities..."
apt-get install -y nvidia-utils-${DRIVER_VERSION}-server

echo "==> Installing matching NVIDIA Fabric Manager..."
apt-get install -y nvidia-fabricmanager-${DRIVER_VERSION}

echo "==> Enabling Fabric Manager service..."
systemctl enable nvidia-fabricmanager

echo "==> Verifying DKMS build status..."
dkms status

echo "==> Done. A reboot is required for the driver to load."
echo "==> After reboot, verify with:"
echo "      nvidia-smi"
echo "      systemctl status nvidia-fabricmanager"
echo "      nvidia-smi nvlink --status"
echo "      nvidia-smi topo -m"
echo "==> Rebooting..."
reboot now
