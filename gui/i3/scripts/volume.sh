#!/bin/sh

volume_notify() {
    # Kill dunst to remove all notifications. Avoid having multiple notifications
    # when pressing multiple times the volume keys to adjust the volume.
    pkill dunst

    mute=`pamixer --get-mute`
    volume=`pamixer --get-volume`

    if [ "$mute" == "true" ]; then
        notify-send Volume "mute ($volume%)"
    else
        notify-send Volume "$volume%"
    fi
}

volume_inc() {
    pamixer --increase 5
    volume_notify
}

volume_dec() {
    pamixer --decrease 5
    volume_notify
}

volume_mute() {
    pamixer --toggle-mute
    volume_notify
}

case $1 in
    "inc")  volume_inc ;;
    "dec")  volume_dec ;;
    "mute") volume_mute ;;
esac
