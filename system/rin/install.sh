#!/bin/sh

# grub
mkdir -p /etc/default
cp $PWD/system/rin/boot/grub /etc/default/grub

# firewall
cp $PWD/system/rin/security/nftables.conf /etc/nftables.conf

# sudo
mkdir -p /etc/sudoers.d
cp $PWD/system/nanoha/security/sudo_group /etc/sudoers.d/group
chmod 0440 /etc/sudoers.d/group

# ssh
mkdir -p /etc/ssh
cp $PWD/system/rin/ssh/sshd_config /etc/ssh/sshd_config
