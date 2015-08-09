#!/bin/sh

# apt
sudo cp $PWD/system/nanoha/etc/apt/sources.list \
        /etc/apt/sources.list
sudo cp -r $PWD/system/nanoha/etc/apt/sources.list.d \
           /etc/apt/sources.list.d

# systemd
sudo cp $PWD/system/nanoha/etc/systemd/logind.conf \
        /etc/systemd/logind.conf

# X11
sudo cp $PWD/system/nanoha/etc/X11/xorg.conf.d/20-intel.conf \
        /etc/X11/xorg.conf.d/20-intel.conf
