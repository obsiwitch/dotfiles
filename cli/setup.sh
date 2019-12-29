#!/bin/bash

DOTDIR="$(realpath "$(dirname "$0")/..")"
PATH="$DOTDIR/cli/bin:$PATH"

# bin
dotln "$DOTDIR/cli/bin/"* "$HOME/.local/bin/"

# shell
dotln "$DOTDIR/cli/shell/profile" "$HOME/.profile"
dotln "$DOTDIR/cli/shell/bashrc" "$HOME/.bashrc"
dotln "$DOTDIR/cli/shell/inputrc" "$HOME/.inputrc"
dotln "$DOTDIR/cli/shell/bashrc.d/"*.sh "$HOME/.bashrc.d/"

# git
dotln "$DOTDIR/cli/git" "$HOME/.config/"
