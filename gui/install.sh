#!/bin/bash

"$PWD/gui/remove.sh"

# bin
mkdir -p "$HOME/.local/bin"
for bin in "$PWD/gui/bin/"*; do
    if [[ ! -f $bin ]]; then continue; fi
    ln -s "$bin" "$HOME/.local/bin/$(basename "${bin%.*}")"
done

# i3
ln -s "$PWD/gui/i3" "$HOME/.i3"

# GTK
ln -s "$PWD/gui/gtk/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"
mkdir -p "$HOME/.config/gtk-3.0"
ln -s "$PWD/gui/gtk/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
ln -s "$PWD/gui/gtk/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"

# Xfce
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
cp "$PWD/gui/Xfce/xfce4-power-manager.xml" \
   "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml"

# Thunar
mkdir -p "$HOME/.config/Thunar"
cp "$PWD/gui/thunar/uca.xml" "$HOME/.config/Thunar/uca.xml"
cp "$PWD/gui/thunar/thunar.xml" \
   "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"

# Notifications
mkdir -p "$HOME/.config/dunst"
ln -s "$PWD/gui/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"

# X
ln -s "$PWD/gui/X/xinitrc" "$HOME/.xinitrc"

# Qt
mkdir -p "$HOME/.bashrc.d"
ln -s "$PWD/gui/Qt/qt.sh" "$HOME/.bashrc.d/qt.sh"

# xdg
ln -s "$PWD/gui/xdg/user-dirs.conf" "$HOME/.config/user-dirs.conf"

# mpv
ln -s "$PWD/gui/mpv" "$HOME/.config/mpv"

# terminal
ln -s "$PWD/gui/kitty" "$HOME/.config/kitty"

# cache
mkdir -p "$HOME/.cache"
ln -s /dev/null "$HOME/.cache/thumbnails"
ln -s /dev/null "$HOME/.thumbnails"
ln -s /dev/null "$HOME/.python_history"
