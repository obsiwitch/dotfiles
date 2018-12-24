#!/bin/sh

# grub
mkdir -p /etc/default
cp $PWD/system/boot/grub /etc/default/grub

# kernel modules
mkdir -p /etc/modprobe.d
cp $PWD/system/kernel/blacklist.conf /etc/modprobe.d/blacklist.conf

# X11
mkdir -p /etc/X11/xorg.conf.d
cp $PWD/system/gui/xorg/* /etc/X11/xorg.conf.d/

# firewall
cp $PWD/system/security/nftables.conf /etc/nftables.conf

# sudo
mkdir -p /etc/sudoers.d
cp $PWD/system/security/sudo_group /etc/sudoers.d/group
chmod 0440 /etc/sudoers.d/group
