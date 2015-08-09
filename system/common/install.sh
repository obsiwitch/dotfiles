#!/bin/sh

# iptables
sudo cp $PWD/system/common/iptables/iptables \
        /etc/network/if-pre-up.d/iptables
sudo cp $PWD/system/common/iptables/iptables.up.rules \
        /etc/iptables.up.rules
sudo cp $PWD/system/common/iptables/ip6tables.up.rules \
        /etc/ip6tables.up.rules
sudo cp $PWD/system/common/iptables/iptables-clear \
        /usr/sbin/iptables-clear
sudo cp $PWD/system/common/iptables/iptables-update \
        /usr/sbin/iptables-update
