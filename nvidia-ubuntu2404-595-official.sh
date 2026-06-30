#!/bin/bash
#
# NVIDIA driver + Fabric Manager installation for SXM/NVSwitch systems
# Ubuntu 24.04 - Server driver branch (required for Fabric Manager / NVLink)
#
# Use this script for any node with NVSwitch-equipped GPUs (e.g. A100/H100 SXM).
# Do NOT use ubuntu-drivers autoinstall on these nodes - it picks the "open"
# driver flavor, which is incompatible with Fabric Manager and will cause
# apt to remove your driver when fabricmanager is installed afterward.
#

set -e

DRIVER_VERSION="595"   # update this to match what's available in your mirror

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
apt-get install -y \
  build-essential \
  dkms

echo "==> Checking available server driver and fabric manager packages..."
apt-cache search nvidia-headless-${DRIVER_VERSION}-server
apt-cache search nvidia-utils-${DRIVER_VERSION}-server
apt-cache search nvidia-fabricmanager-${DRIVER_VERSION}

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
