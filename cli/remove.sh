#!/bin/sh

# bin
for bin in $PWD/cli/bin/*; do
    if [[ ! -f $bin ]]; then continue; fi
    rm $HOME/.local/bin/`basename ${bin%.*}`
done

# shell
rm $HOME/.profile
rm $HOME/.bashrc
rm $HOME/.inputrc
rm $HOME/.prompt.sh
rm $HOME/.fzf.sh

# git
rm $HOME/.config/git
