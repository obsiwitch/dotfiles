#!/bin/bash

# bin
for bin in "$PWD/gui/bin/"*; do
    if [[ ! -f $bin ]]; then continue; fi
    rm "$HOME/.local/bin/$(basename "${bin%.*}")"
done

# i3
rm "$HOME/.i3"

# GTK
rm "$HOME/.gtkrc-2.0"
rm "$HOME/.config/gtk-3.0/gtk.css"
rm "$HOME/.config/gtk-3.0/settings.ini"

# Xfce
rm "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml"

# Thunar
rm "$HOME/.config/Thunar/uca.xml"
rm "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"

# Notifications
rm "$HOME/.config/dunst/dunstrc"

# X
rm "$HOME/.xinitrc"

# Qt
rm "$HOME/.config/Trolltech.conf"

# xdg
rm "$HOME/.config/user-dirs.conf"

# mpv
rm "$HOME/.config/mpv"

# terminal
rm "$HOME/.config/kitty"

# cache
rm -rf "$HOME/.cache/thumbnails"
rm -rf "$HOME/.thumbnails"
rm "$HOME/.python_history"
