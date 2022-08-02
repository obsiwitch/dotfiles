#!/bin/bash

set -o errexit -o nounset -o xtrace

dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
dotuserp="$dotfilesp/user"
PATH="$dotfilesp/user/bin:$PATH"

# i3
dotln "$dotuserp/i3" "$HOME/.config/"

# GTK
dotln "$dotuserp/gtk/gtk-3.0" "$HOME/.config/"
dotln "$dotuserp/gtk/gtk-4.0" "$HOME/.config/"

# file manager
dconf reset -f '/org/cinnamon/desktop/applications/terminal/'
dconf reset -f '/org/nemo/'
dconf load / < "$dotuserp/nemo/dconf"
dotln "$dotuserp/nemo/actions" "$HOME/.local/share/nemo/"

# notifications
dotln "$dotuserp/dunst" "$HOME/.config/"

# xorg
dotln "$dotuserp/xorg/xinitrc" "$HOME/.xinitrc"

# xdg
dotln "$dotuserp/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$dotuserp/mpv" "$HOME/.config/"

# terminal
dconf reset -f '/org/mate/terminal/'
dconf load / < "$dotuserp/mate-terminal/dconf"

# gedit
dconf reset -f '/org/gnome/desktop/applications/terminal/'
dconf reset -f '/org/gnome/gedit/'
dconf load / < "$dotuserp/gedit/dconf"

# desktop entries
dotln "$dotuserp/desktop" "$HOME/.local/share/applications"

# blender
blender_version="$(blender -v | awk 'NR==1 {print $2}')"
blender_version="${blender_version%.*}"
dotln "$dotuserp/blender/scripts" \
      "$HOME/.config/blender/$blender_version/"
"$dotuserp/blender/userprefs.py"

# wine
wine reg add 'HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations' /v 'Enable' /d 'N' /f
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /v 'UseTakeFocus' /d 'N' /f

