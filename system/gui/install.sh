#!/bin/sh

# Adwaita-i3-tweaks
sudo git clone --depth 1 https://gitlab.com/Obside/Adwaita-i3-tweaks.git \
    /usr/share/themes/Adwaita-i3-tweaks

# chromium default flags
sudo cp $PWD/system/gui/chromium-flags \
        /etc/chromium.d/default-flags

# xflock4
sudo cp $PWD/system/gui/xflock4 \
        /usr/bin/xflock4
