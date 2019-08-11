#!/bin/bash

PATH="$PWD/cli/bin:$PATH"

# bin
dotln "$PWD/gui/bin/"* "$HOME/.local/bin/"

# i3
dotln "$PWD/gui/i3" "$HOME/.config/"

# GTK
dotln "$PWD/gui/gtk/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"
dotln "$PWD/gui/gtk/gtk-3.0" "$HOME/.config/"

# power manager
dotcp "$PWD/gui/Xfce/xfce4-power-manager.xml" \
      "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"

# file manager
dotcp "$PWD/gui/thunar/uca.xml" "$HOME/.config/Thunar/"
dotcp "$PWD/gui/thunar/thunar.xml" \
      "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"

# notifications
dotln "$PWD/gui/dunst" "$HOME/.config/"

# X
dotln "$PWD/gui/X/xinitrc" "$HOME/.xinitrc"

# Qt
dotln "$PWD/gui/Qt/qt.sh" "$HOME/.bashrc.d/"

# xdg
dotln "$PWD/gui/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$PWD/gui/mpv" "$HOME/.config/"
dotln "$PWD/gui/desktop/mpvg.desktop" "$HOME/.local/share/applications/"

# terminal
dotln "$PWD/gui/kitty" "$HOME/.config/"

# cache
dotln '/dev/null' "$HOME/.cache/thumbnails"
dotln '/dev/null' "$HOME/.thumbnails"
dotln '/dev/null' "$HOME/.python_history"
