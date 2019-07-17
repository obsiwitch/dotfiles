#!/bin/bash

choice=$(
    echo 'reload sleep hibernate logout restart shutdown' \
        | tr ' ' '\n' \
        | dmenu
)
case "$choice" in
    reload)    screenlayout && i3-msg restart;;
    sleep)     xflock4 ; systemctl suspend;;
    hibernate) xflock4 ; systemctl hibernate;;
    logout)    i3-msg exit;;
    restart)   systemctl reboot;;
    shutdown)  systemctl poweroff;;
esac
