#!/bin/bash

# bin
for bin in "$PWD/cli/bin/"*; do
    if [[ ! -f $bin ]]; then continue; fi
    rm "$HOME/.local/bin/$(basename "${bin%.*}")"
done

# shell
rm "$HOME/.profile"
rm "$HOME/.bashrc"
rm "$HOME/.inputrc"
rm "$HOME/.bashrc.d/complete.sh"
rm "$HOME/.bashrc.d/prompt.sh"
rmdir "$HOME/.bashrc.d/"

# git
rm "$HOME/.config/git"
