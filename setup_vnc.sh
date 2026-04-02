#!/bin/bash

# --- 1. Update and Install Core Desktop Components ---
echo "Updating system and installing XFCE4..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y xfce4 xfce4-goodies tigervnc-standalone-server dbus-x11 xterm autocutsel

# --- 2. Kill the Snap Firefox and install the Native PPA version ---
echo "Replacing Firefox Snap with Native PPA version..."
sudo snap remove firefox
sudo apt purge -y firefox

# Add Mozilla PPA
sudo add-apt-repository -y ppa:mozillateam/ppa

# Create the Pinning file to block the Snap from coming back
sudo bash -c 'cat <<EOF > /etc/apt/preferences.d/mozilla-firefox
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1
EOF'

sudo apt update && sudo apt install -y firefox

# --- 3. Configure VNC for the current user ---
echo "Configuring VNC xstartup..."
mkdir -p ~/.vnc

# Set VNC password (non-interactive if you want, but safer to let it prompt)
if [ ! -f ~/.vnc/passwd ]; then
    echo "Please set your VNC password now:"
    vncpasswd
fi

# Create the xstartup file
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

# Start XFCE Desktop
exec startxfce4
EOF

chmod +x ~/.vnc/xstartup

# --- 4. Final Cleanup and Start ---
# Kill any existing sessions on :1
vncserver -kill :1 > /dev/null 2>&1
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

echo "--------------------------------------------------------"
echo "Setup Complete!"
echo "To start your server manually, run:"
echo "vncserver -localhost no -geometry 1920x1080 :1"
echo "--------------------------------------------------------"
