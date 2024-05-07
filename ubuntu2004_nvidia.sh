#!/bin/bash

sudo lshw -numeric -C display
sleep 10
sudo apt install -y ubuntu-drivers-common && sudo ubuntu-drivers autoinstall && sleep 10 && sudo reboot now
