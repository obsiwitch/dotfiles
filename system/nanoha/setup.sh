#!/bin/bash

# kernel modules
dotcp "$PWD/system/nanoha/kernel/blacklist.conf" '/etc/modprobe.d/'

# X11
dotcp "$PWD/system/nanoha/xorg/"* '/etc/X11/xorg.conf.d/'

# firewall
dotcp "$PWD/system/nanoha/security/nftables.conf" '/etc/'

# sudo
dotcp "$PWD/system/nanoha/security/sudo_group" '/etc/sudoers.d/group'
chmod 0440 '/etc/sudoers.d/group'
