#!/bin/sh

# iptables
sudo cp $PWD/system/common/etc/network/if-pre-up.d/iptables \
        /etc/network/if-pre-up.d/iptables
sudo cp $PWD/system/common/etc/iptables.up.rules \
        /etc/iptables.up.rules
sudo cp $PWD/system/common/etc/ip6tables.up.rules \
        /etc/ip6tables.up.rules
sudo cp $PWD/system/common/usr/sbin/iptables-clear \
        /usr/sbin/iptables-clear
sudo cp $PWD/system/common/usr/sbin/iptables-update \
        /usr/sbin/iptables-update

# xflock4
sudo cp $PWD/system/common/usr/bin/xflock4 \
        /usr/bin/xflock4
