#!/bin/bash

DOTDIR="$(realpath "$(dirname "$0")/..")"
PATH="$DOTDIR/cli/bin:$PATH"

# bin
dotln "$DOTDIR/gui/bin/"* "$HOME/.local/bin/"

# i3
dotln "$DOTDIR/gui/i3" "$HOME/.config/"

# GTK
dotln "$DOTDIR/gui/gtk/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"
dotln "$DOTDIR/gui/gtk/gtk-3.0" "$HOME/.config/"

# power manager
dotcp "$DOTDIR/gui/Xfce/xfce4-power-manager.xml" \
      "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"

# file manager
dotcp "$DOTDIR/gui/thunar/uca.xml" "$HOME/.config/Thunar/"
dotcp "$DOTDIR/gui/thunar/thunar.xml" \
      "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"
dconf load / < "$DOTDIR/gui/nemo/dconf"
dotln "$DOTDIR/gui/nemo/actions" "$HOME/.local/share/nemo/"

# notifications
dotln "$DOTDIR/gui/dunst" "$HOME/.config/"

# X
dotln "$DOTDIR/gui/X/xinitrc" "$HOME/.xinitrc"

# Qt
dotln "$DOTDIR/gui/Qt/qt.sh" "$HOME/.bashrc.d/"

# xdg
dotln "$DOTDIR/gui/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$DOTDIR/gui/mpv" "$HOME/.config/"
dotln "$DOTDIR/gui/desktop/mpvg.desktop" "$HOME/.local/share/applications/"

# terminal
dotln "$DOTDIR/gui/kitty" "$HOME/.config/"

# cache
dotln '/dev/null' "$HOME/.python_history"
