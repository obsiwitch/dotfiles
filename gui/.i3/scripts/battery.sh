#!/bin/sh

.i3/scripts/battery.perl

# left click, xfce4-power-manager-settings
case $BLOCK_BUTTON in
  1) xfce4-power-manager-settings --device-id=/org/freedesktop/UPower/devices/battery_BAT0 ;;
esac
