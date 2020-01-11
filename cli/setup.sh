#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/..")"
DOTCLIP="$DOTFILESP/cli"
PATH="$DOTFILESP/cli/bin:$PATH"

# bin
dotln "$DOTCLIP/bin" "$HOME/.local/dotclibin"

# shell
dotln "$DOTCLIP/shell/profile" "$HOME/.profile"
dotln "$DOTCLIP/shell/bashrc" "$HOME/.bashrc"
dotln "$DOTCLIP/shell/inputrc" "$HOME/.inputrc"
dotln "$DOTCLIP/shell/bashrc.d/"*.sh "$HOME/.bashrc.d/"

# git
dotln "$DOTCLIP/git" "$HOME/.config/"
