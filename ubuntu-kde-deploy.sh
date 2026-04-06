#!/bin/bash

# --- 1. System Update & Core Desktop (KDE Plasma) ---
echo "Installing KDE Plasma Desktop and XRDP..."
sudo apt update && sudo apt upgrade -y

# Minimal KDE install to keep the server lean
sudo apt install -y kde-plasma-desktop xrdp wget gpg apt-transport-https

# --- 2. Configure XRDP for KDE ---
echo "Configuring XRDP to use Plasma..."

# Add xrdp user to the ssl-cert group so it can use the built-in certs
sudo adduser xrdp ssl-cert

# Set the session to Plasma for XRDP
# This creates/overwrites the .xsession file in the user's home directory
cat <<EOF > ~/.xsession
export DESKTOP_SESSION=plasma
export XDG_CURRENT_DESKTOP=KDE
export KDE_SESSION_VERSION=5
export KDE_FULL_SESSION=true
exec startplasma-x11
EOF

# Restart the service to apply changes
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# --- 3. Firefox (Native PPA - No Snaps) ---
echo "Removing Firefox Snap and installing Native PPA..."
sudo snap remove firefox && sudo apt purge -y firefox
sudo add-apt-repository -y ppa:mozillateam/ppa

sudo bash -c 'cat <<EOF > /etc/apt/preferences.d/mozilla-firefox
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1
EOF'

sudo apt update && sudo apt install -y firefox

# --- 4. Google Chrome & VS Code ---
echo "Installing Chrome and VS Code..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update && sudo apt install -y code

echo "--------------------------------------------------------"
echo "KDE RDP SETUP COMPLETE!"
echo "--------------------------------------------------------"
echo "1. Connection Port: 3389"
echo "2. Use your Ubuntu Linux username and password to log in."
echo "3. Point Cloudflare to tcp://$(hostname -I | awk '{print $1}'):3389"
echo "--------------------------------------------------------"
