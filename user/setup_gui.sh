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
dotln "$DOTUSERP/kitty" "$HOME/.config/"

# blender
if command -v blender; then
    blender_version="$(blender -v | awk 'NR==1 {print $2}')"
    blender_version="${blender_version%.*}"
    dotln "$DOTUSERP/blender/scripts" \
          "$HOME/.config/blender/$blender_version/"
    dotln "$DOTUSERP/blender/blenderimport.desktop" \
          "$HOME/.local/share/applications/"

    "$DOTUSERP/blender/userprefs.py"
fi > /dev/null

# atom
dotln "$DOTUSERP/atom/"* "$HOME/.atom/"
apm-needed-install() {
    local package; for package in "$@"; do
        [[ -d "$HOME/.atom/packages/$package" ]] || apm install "$package"
    done
}
apm-needed-install atom-beautify dbclick-tree-view language-generic-config \
    open-terminal-here split-diff
