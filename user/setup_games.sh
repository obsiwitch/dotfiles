#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$sourcep/bin:$PATH"

# wine
winetricks settings mimeassoc=off # disable exporting MIME-type file associations to the native desktop
winetricks settings isolate_home # remove links to home
winetricks dlls dxvk
winetricks dlls corefonts
winetricks settings alldlls=default # remove all DLL overrides

# retroarch
cp -r "$sourcep/retroarch" "$HOME/.config/"
