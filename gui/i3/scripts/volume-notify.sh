#!/bin/sh

# Kill dunst to remove all notifications. Avoid having multiple notifications
# when pressing multiple times the volume keys to adjust the volume.
pkill dunst

volume=`amixer get Master | awk -F "[][]" '/%/ { print $2 " " $4 }' | uniq`

notify-send Volume "$volume"
