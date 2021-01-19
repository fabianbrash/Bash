#!/bin/bash

#REF:https://www.cyberciti.biz/faq/install-and-configure-tigervnc-server-on-ubuntu-18-04/

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

apt install -y tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer

#All commands below must be run as the user you want to connect with
vncpasswd

cat > ~/.vnc/xstartup <<EOF
#!/bin/sh
# Start Gnome 3 Desktop 
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
vncconfig -iconic &
dbus-launch --exit-with-session gnome-session &
EOF

vncserver -list

ssh user@remote-server -L 5901:127.0.0.1:5901

