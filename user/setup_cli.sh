#!/bin/bash

set -o errexit -o nounset -o xtrace

DOTFILESP="$(realpath "${BASH_SOURCE%/*}/..")"
DOTUSERP="$DOTFILESP/user"
PATH="$DOTFILESP/user/bin:$PATH"

# bin
dotln "$DOTUSERP/bin" "$HOME/.local/dotbin"

# lib
dotln "$DOTUSERP/lib" "$HOME/.local/dotlib"

# shell
dotln "$DOTUSERP/shell/profile" "$HOME/.profile"
dotln "$DOTUSERP/shell/bashrc" "$HOME/.bashrc"
dotln "$DOTUSERP/shell/inputrc" "$HOME/.inputrc"
dotln "$DOTUSERP/shell/bashrc.d" "$HOME/.config/"

# git
dotln "$DOTUSERP/git" "$HOME/.config/"

# micro
dotln "$DOTUSERP/micro" "$HOME/.config/"
