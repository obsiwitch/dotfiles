#!/bin/bash

set -o errexit -o nounset -o xtrace

DOTFILESP="$(realpath "$(dirname "$0")/..")"
DOTUSERP="$DOTFILESP/user"
PATH="$DOTFILESP/user/bin:$PATH"

# i3
dotln "$DOTUSERP/i3" "$HOME/.config/"

# GTK
dotln "$DOTUSERP/gtk/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"
dotln "$DOTUSERP/gtk/gtk-3.0" "$HOME/.config/"

# power manager
"$DOTUSERP/xfce4/xfpm.sh"

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
    "$DOTUSERP/blender/userprefs.py"
fi > /dev/null
dotln "$DOTUSERP/blender/blenderimport.desktop" "$HOME/.local/share/applications/"

# atom
dotln "$DOTUSERP/atom/config.cson" "$HOME/.atom/"
apm disable about archive-view autosave background-tips bookmarks dalek \
    exception-reporting github image-view keybinding-resolver metrics \
    open-on-github styleguide symbols-view welcome kite
apm-needed-install() {
    local package; for package in "$@"; do
        [[ -d "$HOME/.atom/packages/$package" ]] || apm install "$package"
    done
}
apm-needed-install atom-beautify autocomplete-python language-generic-config \
    language-kotlin language-lua language-openscad language-tex open-terminal-here \
    split-diff
pip install --user --upgrade jedi # autocomplete-python dependency
