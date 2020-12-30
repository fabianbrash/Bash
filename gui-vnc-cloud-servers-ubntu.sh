#!/bin/bash

#REF:https://www.suhendro.com/2019/04/ubuntu-cloud-desktop-adding-gui-to-your-cloud-server-instance/

#Make sure we are root

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

apt install -y tightvncserver xfonts-75dpi xfonts-100dpi gsfonts-x11

apt install -y ubuntu-mate-core

#Startup vnc server
vncserver

##Kill vnc server
#vncserver -kill :1 (not :1 if that's the one you want to kill vnc can have multiple sessions i.e. :2, :3

#Backup our config
cp ~/.vnc/xstartup ~/.vnc/xstartup.bak

#Let's use a heredoc to overwrite our document
#Note I might have to move this out, since we are sudo which file is being updated?
cat > ~/.vnc/xstartup <<EOF
#!/bin/sh
unset DBUS_SESSION_BUS_ADDRESS
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
x-window-manager &
mate-session &
EOF

##This is the best editor I found to work under vnc, atom and vscode don't
cd ~\Downloads
curl -LO https://github.com/adobe/brackets/releases/download/release-1.14.1/Brackets.Release.1.14.1.64-bit.deb
sleep 5

dpkg -i Brackets.Release.1.14.1.64-bit.deb
