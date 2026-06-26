#!/bin/bash
#
# Manual NVIDIA driver installation via apt
# Ubuntu 24.04
#

set -e

echo "==> Updating package lists..."
apt-get update

echo "==> Installing required dependencies..."
apt-get install -y \
  linux-headers-$(uname -r) \
  build-essential \
  dkms

echo "==> Checking for available NVIDIA drivers..."
apt-cache search nvidia-driver

echo "==> Installing latest recommended NVIDIA driver..."
# ubuntu-drivers will pick the recommended driver for your GPU automatically
apt-get install -y ubuntu-drivers-common
ubuntu-drivers autoinstall

echo "==> Verifying installation..."
nvidia-smi

echo "==> Done. A reboot may be required for the driver to load."

echo "==> Rebooting..."
reboot now
