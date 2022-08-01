#!/bin/bash

set -o errexit -o nounset -o xtrace

DOTFILESP="$(realpath "${BASH_SOURCE%/*}/..")"
DOTUSERP="$DOTFILESP/user"
PATH="$DOTFILESP/user/bin:$PATH"

# i3
dotln "$DOTUSERP/i3" "$HOME/.config/"

# GTK
dotln "$DOTUSERP/gtk/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"
dotln "$DOTUSERP/gtk/gtk-3.0" "$HOME/.config/"

# file manager
dconf reset -f '/org/cinnamon/desktop/applications/terminal/'
dconf reset -f '/org/nemo/'
dconf load / < "$DOTUSERP/nemo/dconf"
dotln "$DOTUSERP/nemo/actions" "$HOME/.local/share/nemo/"

# notifications
dotln "$DOTUSERP/dunst" "$HOME/.config/"

# xorg
dotln "$DOTUSERP/xorg/xinitrc" "$HOME/.xinitrc"

# xdg
dotln "$DOTUSERP/xdg/user-dirs.conf" "$HOME/.config/"

# mpv
dotln "$DOTUSERP/mpv" "$HOME/.config/"

# terminal
dconf reset -f '/org/mate/terminal/'
dconf load / < "$DOTUSERP/mate-terminal/dconf"

# gedit
dconf reset -f '/org/gnome/desktop/applications/terminal/'
dconf reset -f '/org/gnome/gedit/'
dconf load / < "$DOTUSERP/gedit/dconf"

# desktop entries
dotln "$DOTUSERP/desktop" "$HOME/.local/share/applications"

# blender
blender_version="$(blender -v | awk 'NR==1 {print $2}')"
blender_version="${blender_version%.*}"
dotln "$DOTUSERP/blender/scripts" \
      "$HOME/.config/blender/$blender_version/"
"$DOTUSERP/blender/userprefs.py"

# wine
wine reg add 'HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations' /v 'Enable' /d 'N' /f
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /v 'UseTakeFocus' /d 'N' /f

