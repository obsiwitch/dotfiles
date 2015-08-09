#!/bin/sh

# iptables
sudo rm /etc/network/if-pre-up.d/iptables
sudo rm /etc/iptables.up.rules
sudo rm /etc/ip6tables.up.rules
sudo rm /usr/sbin/iptables-clear
sudo rm /usr/sbin/iptables-update
