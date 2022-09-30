#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$sourcep/bin:$PATH"

# sway
dotln "$sourcep/sway" "$HOME/.config/"
dotln "$sourcep/swaylock" "$HOME/.config/"

# GTK
dotln "$sourcep/gtk/gtk-3.0" "$HOME/.config/"
dotln "$sourcep/gtk/gtk-4.0" "$HOME/.config/"
dconf reset -f '/org/gnome/desktop/interface/'
dconf load / < "$sourcep/gtk/dconf"

# file manager
dconf reset -f '/org/gnome/nautilus/'
dconf load / < "$sourcep/nautilus/dconf"

# notifications
dotln "$sourcep/dunst" "$HOME/.config/"

# xdg
dotln "$sourcep/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$sourcep/mpv" "$HOME/.config/"

# terminal
dconf reset -f '/org/gnome/terminal/'
dconf load / < "$sourcep/gnome-terminal/dconf"

# gedit
dconf reset -f '/org/gnome/gedit/'
dconf load / < "$sourcep/gedit/dconf"

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

# wine
wine reg add 'HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations' /v 'Enable' /d 'N' /f
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /v 'UseTakeFocus' /d 'N' /f

