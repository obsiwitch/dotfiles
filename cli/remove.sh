#!/bin/sh

# bin
for bin in $PWD/cli/bin/*; do
    if [[ ! -f $bin ]]; then continue; fi
    rm $HOME/.local/bin/`basename ${bin%.*}`
done

# shell
rm $HOME/.bashrc
rm $HOME/.prompt.sh
rm $HOME/.inputrc
rm $HOME/.profile

# git
rm $HOME/.gitconfig
