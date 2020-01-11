#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/..")"
DOTGUIP="$DOTFILESP/gui"
PATH="$DOTFILESP/cli/bin:$PATH"

# bin
dotln "$DOTGUIP/bin" "$HOME/.local/dotguibin"

# i3
dotln "$DOTGUIP/i3" "$HOME/.config/"

# GTK
dotln "$DOTGUIP/gtk/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"
dotln "$DOTGUIP/gtk/gtk-3.0" "$HOME/.config/"

# power manager
dotcp "$DOTGUIP/Xfce/xfce4-power-manager.xml" \
      "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"

# file manager
dotcp "$DOTGUIP/thunar/uca.xml" "$HOME/.config/Thunar/"
dotcp "$DOTGUIP/thunar/thunar.xml" \
      "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"
dconf load / < "$DOTGUIP/nemo/dconf"
dotln "$DOTGUIP/nemo/actions" "$HOME/.local/share/nemo/"

# notifications
dotln "$DOTGUIP/dunst" "$HOME/.config/"

# X
dotln "$DOTGUIP/X/xinitrc" "$HOME/.xinitrc"

# Qt
dotln "$DOTGUIP/Qt/qt.sh" "$HOME/.bashrc.d/"

# xdg
dotln "$DOTGUIP/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$DOTGUIP/mpv" "$HOME/.config/"
dotln "$DOTGUIP/desktop/mpvg.desktop" "$HOME/.local/share/applications/"

# terminal
dotln "$DOTGUIP/kitty" "$HOME/.config/"

# cache
dotln '/dev/null' "$HOME/.python_history"
