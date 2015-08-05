#!/bin/sh

case $BLOCK_BUTTON in
    1) .i3/scripts/calendar_notif.sh ;; # left click, display calendar
esac

date '+%d/%m/%Y - %H:%M'
