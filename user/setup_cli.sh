#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$sourcep/bin:$PATH"

# bin
dotln "$sourcep/bin" "$HOME/.local/dotbin"

# shell
dotln "$sourcep/shell/profile" "$HOME/.profile"
dotln "$sourcep/shell/bashrc" "$HOME/.bashrc"
dotln "$sourcep/shell/inputrc" "$HOME/.inputrc"
dotln "$sourcep/shell/bashrc.d" "$HOME/.config/"

# git
dotln "$sourcep/git" "$HOME/.config/"

# ranger
dotln "$sourcep/ranger" "$HOME/.config/"

# micro
dotln "$sourcep/micro" "$HOME/.config/"
micro -plugin install fzf
micro -plugin update
