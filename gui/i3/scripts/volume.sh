#!/bin/sh

volume_notify() {
    # Kill dunst to remove all notifications. Avoid having multiple notifications
    # when pressing multiple times the volume keys to adjust the volume.
    pkill dunst

    mute=`pactl list sinks | grep 'Mute:' | tr -d '\t'`
    volume=`pactl list sinks | grep -P '^\tVolume:' | cut -d'/' -f2 | tr -d ' '`

    if [ "$mute" == "Mute: yes" ]; then
        notify-send Volume "mute ($volume)"
    else
        notify-send Volume "$volume"
    fi
}

volume_inc() {
    pactl set-sink-volume 0 +5%
    volume_notify
}

volume_dec() {
    pactl set-sink-volume 0 -5%
    volume_notify
}

volume_mute() {
    pactl set-sink-mute 0 toggle
    volume_notify
}

case $1 in
    "inc") volume_inc ;;
    "dec") volume_dec ;;
    "mute") volume_mute ;;
esac
