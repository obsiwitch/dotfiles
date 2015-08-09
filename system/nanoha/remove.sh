#!/bin/sh

# apt
sudo rm /etc/apt/sources.list
sudo rm -rf /etc/apt/sources.list.d

# systemd
sudo rm /etc/systemd/logind.conf

# X11
sudo rm /etc/X11/xorg.conf.d/20-intel.conf
