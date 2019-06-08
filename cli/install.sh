#!/bin/bash

"$PWD/cli/remove.sh"

# bin
mkdir -p "$HOME/.local/bin"
for bin in "$PWD/cli/bin/"*; do
    if [[ ! -f $bin ]]; then continue; fi
    ln -s "$bin" "$HOME/.local/bin/$(basename "${bin%.*}")"
done

# shell
ln -s "$PWD/cli/shell/profile" "$HOME/.profile"
ln -s "$PWD/cli/shell/bashrc" "$HOME/.bashrc"
ln -s "$PWD/cli/shell/inputrc" "$HOME/.inputrc"
mkdir -p "$HOME/.bashrc.d"
ln -s "$PWD/cli/shell/bashrc.d/"*.sh "$HOME/.bashrc.d"

# git
mkdir -p "$HOME/.config"
ln -s "$PWD/cli/git" "$HOME/.config/git"
