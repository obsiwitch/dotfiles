#!/bin/bash

set -o errexit -o nounset -o xtrace

dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
dotuserp="$dotfilesp/user"
PATH="$dotfilesp/user/bin:$PATH"

# bin
dotln "$dotuserp/bin" "$HOME/.local/dotbin"

# lib
dotln "$dotuserp/lib" "$HOME/.local/dotlib"

# shell
dotln "$dotuserp/shell/profile" "$HOME/.profile"
dotln "$dotuserp/shell/bashrc" "$HOME/.bashrc"
dotln "$dotuserp/shell/inputrc" "$HOME/.inputrc"
dotln "$dotuserp/shell/bashrc.d" "$HOME/.config/"

# git
dotln "$dotuserp/git" "$HOME/.config/"

# micro
dotln "$dotuserp/micro" "$HOME/.config/"
