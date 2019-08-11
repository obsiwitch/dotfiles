#!/bin/bash

PATH="$PWD/cli/bin:$PATH"

# bin
dotln "$PWD/cli/bin/"* "$HOME/.local/bin/"

# shell
dotln "$PWD/cli/shell/profile" "$HOME/.profile"
dotln "$PWD/cli/shell/bashrc" "$HOME/.bashrc"
dotln "$PWD/cli/shell/inputrc" "$HOME/.inputrc"
dotln "$PWD/cli/shell/bashrc.d/"*.sh "$HOME/.bashrc.d/"

# git
dotln "$PWD/cli/git" "$HOME/.config/"
