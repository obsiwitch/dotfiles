#!/bin/sh

# apt
sudo cp $PWD/system/nanoha/etc/apt/sources.list \
        /etc/apt/sources.list

# systemd
sudo cp $PWD/system/nanoha/etc/systemd/logind.conf \
        /etc/systemd/logind.conf

# X11
sudo cp $PWD/system/nanoha/etc/X11/xorg.conf.d/20-intel.conf \
        /etc/X11/xorg.conf.d/20-intel.conf
sudo cp $PWD/system/nanoha/etc/X11/xorg.conf.d/50-synaptics.conf \
        /etc/X11/xorg.conf.d/50-synaptics.conf
