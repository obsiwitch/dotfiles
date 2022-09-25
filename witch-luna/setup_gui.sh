#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$sourcep/bin:$PATH"

# i3
dotln "$sourcep/i3" "$HOME/.config/"

# GTK
dotln "$sourcep/gtk/gtk-3.0" "$HOME/.config/"
dotln "$sourcep/gtk/gtk-4.0" "$HOME/.config/"

# file manager
dconf reset -f '/org/cinnamon/desktop/applications/terminal/'
dconf reset -f '/org/nemo/'
dconf load / < "$sourcep/nemo/dconf"
dotln "$sourcep/nemo/actions" "$HOME/.local/share/nemo/"

# notifications
dotln "$sourcep/dunst" "$HOME/.config/"

# xorg
dotln "$sourcep/xorg/xinitrc" "$HOME/.xinitrc"

# xdg
dotln "$sourcep/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$sourcep/mpv" "$HOME/.config/"

# terminal
dconf reset -f '/org/mate/terminal/'
dconf load / < "$sourcep/mate-terminal/dconf"

# gedit
dconf reset -f '/org/gnome/desktop/applications/terminal/'
dconf reset -f '/org/gnome/gedit/'
dconf load / < "$sourcep/gedit/dconf"

# desktop entries
dotln "$sourcep/desktop" "$HOME/.local/share/applications"

# blender
blender_version="$(blender -v | awk 'NR==1 {print $2}')"
blender_version="${blender_version%.*}"
dotln "$sourcep/blender/scripts" \
      "$HOME/.config/blender/$blender_version/"
"$sourcep/blender/userprefs.py"

# wine
wine reg add 'HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations' /v 'Enable' /d 'N' /f
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /v 'UseTakeFocus' /d 'N' /f

