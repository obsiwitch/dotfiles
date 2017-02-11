#!/bin/sh

$PWD/cli/remove.sh

# Bin
mkdir -p $HOME/Bin
ln -s $PWD/cli/bin/* $HOME/Bin/

# Bash
ln -s $PWD/cli/shell/bashrc $HOME/.bashrc
ln -s $PWD/cli/shell/prompt.sh $HOME/.prompt.sh
ln -s $PWD/cli/shell/inputrc $HOME/.inputrc

# Profile
ln -s $PWD/cli/shell/profile $HOME/.profile
