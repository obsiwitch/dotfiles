#!/bin/sh

# chromium default flags
sudo cp $PWD/system/gui/chromium-flags \
        /etc/chromium.d/default-flags

# xflock4
sudo cp $PWD/system/gui/xflock4 \
        /usr/bin/xflock4
