#!/bin/bash

layout_laptop() {
    xrandr --output HDMI1 --off \
           --output eDP1  --mode 1920x1080 --pos 0x0 --rotate normal
    wallpaper
}

layout_home() {
    xrandr --output HDMI1 --mode 1920x1080 --pos 0x0    --rotate normal \
           --output eDP1  --mode 1920x1080 --pos 1920x0 --rotate normal
    wallpaper
}

if   [ "$1" == "laptop" ]; then layout_laptop
elif [ "$1" == "home" ]; then layout_home
else echo "usage: $(basename "$0") <laptop | home>"; fi
