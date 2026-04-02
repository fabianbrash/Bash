#!/bin/bash

# --- 1. Update and Install Core Desktop Components ---
echo "Updating system and installing XFCE4..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y xfce4 xfce4-goodies tigervnc-standalone-server dbus-x11 xterm autocutsel wget gpg apt-transport-https

# --- 2. Firefox: Kill the Snap, Install the Native PPA ---
echo "Replacing Firefox Snap with Native PPA version..."
sudo snap remove firefox
sudo apt purge -y firefox
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

# --- 3. Install Google Chrome (Official .deb) ---
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# --- 4. Install VS Code (Official Repo) ---
echo "Installing VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update && sudo apt install -y code

# --- 5. Configure VNC for the Current User ---
echo "Configuring VNC xstartup..."
mkdir -p ~/.vnc

if [ ! -f ~/.vnc/passwd ]; then
    echo "Please set your VNC password now:"
    vncpasswd
fi

cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Fix for Clipboard Sync
autocutsel -fork
autocutsel -s CLIPBOARD -fork

# Ensure D-Bus is launched correctly for Ubuntu 24.04
if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval \$(dbus-launch --sh-syntax --exit-with-session)
fi

# Optimization: Disable screensaver and power management for VNC
xfconf-query -c xfce4-screensaver -p /saver/enabled -n -t bool -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -n -t int -s 0

# Start XFCE Desktop
exec startxfce4
EOF

chmod +x ~/.vnc/xstartup

# --- 6. Cleanup and Initial Start ---
vncserver -kill :1 > /dev/null 2>&1
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

echo "--------------------------------------------------------"
echo "SETUP COMPLETE!"
echo "--------------------------------------------------------"
echo "STEP 1: Run 'vncpasswd' to set your password."
echo "STEP 2: Launch with: vncserver -localhost no -geometry 1920x1080 :1"
echo "STEP 3: Point Cloudflare to tcp://$(hostname -I | awk '{print $1}'):5901"
echo "--------------------------------------------------------"
