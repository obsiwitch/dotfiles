#!/bin/bash

layout_laptop() {
    xrandr --output HDMI1 --off \
           --output eDP1  --auto
}

layout_home() {
    xrandr --output HDMI1 --auto --left-of eDP1 \
           --output eDP1  --auto
}

if   [ "$1" == "laptop" ]; then layout_laptop
elif [ "$1" == "home" ]; then layout_home
else echo "usage: $(basename "$0") <laptop | home>"; fi
