#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$sourcep/bin:$PATH"

# i3
dotln "$sourcep/i3" "$HOME/.config/"
dotln "$sourcep/i3/xinitrc" "$HOME/.xinitrc"

# sway
dotln "$sourcep/sway" "$HOME/.config/"
dotln "$sourcep/swaylock" "$HOME/.config/"
dotln "$sourcep/waybar" "$HOME/.config/"

# GTK
dotln "$sourcep/gtk/gtk-3.0" "$HOME/.config/"
dotln "$sourcep/gtk/gtk-4.0" "$HOME/.config/"
dconf reset -f '/org/gnome/desktop/interface/'
dconf load / < "$sourcep/gtk/dconf"

# terminal
dotln "$sourcep/alacritty" "$HOME/.config/"

# file manager
dconf reset -f '/org/cinnamon/desktop/applications/terminal/'
dconf reset -f '/org/nemo/'
dconf load / < "$sourcep/nemo/dconf"
dotln "$sourcep/nemo/actions" "$HOME/.local/share/nemo/"

# notifications
dotln "$sourcep/dunst" "$HOME/.config/"

# xdg
dotln "$sourcep/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$sourcep/mpv" "$HOME/.config/"

# desktop entries
dotln "$sourcep/desktop" "$HOME/.local/share/applications"

# blender
if  [[ -v DISPLAY ]]; then
    blender_version="$(blender -v | awk 'NR==1 {print $2}')"
    blender_version="${blender_version%.*}"
    dotln "$sourcep/blender/scripts" \
          "$HOME/.config/blender/$blender_version/"
    "$sourcep/blender/userprefs.py"
fi
