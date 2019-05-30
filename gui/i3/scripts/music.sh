#!/bin/bash

music=$(
    quodlibet --print-playing \
    "<title>\n<album>\n<albumartist|<albumartist>|<artist>>"
)

notify-send "Music" "$music"
