#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$dotfilesp/user/bin:$PATH"

# bin
dotln "$sourcep/bin" "$HOME/.local/dotbin"

# lib
dotln "$sourcep/lib" "$HOME/.local/dotlib"

# shell
dotln "$sourcep/shell/profile" "$HOME/.profile"
dotln "$sourcep/shell/bashrc" "$HOME/.bashrc"
dotln "$sourcep/shell/inputrc" "$HOME/.inputrc"
dotln "$sourcep/shell/bashrc.d" "$HOME/.config/"

# git
dotln "$sourcep/git" "$HOME/.config/"

# micro
dotln "$sourcep/micro" "$HOME/.config/"
