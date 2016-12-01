#!/bin/sh

# Bin
mkdir -p $HOME/Bin
ln -s $PWD/cli/bin/* $HOME/Bin/

# Bash
ln -s $PWD/cli/shell/bashrc $HOME/.bashrc
ln -s $PWD/cli/shell/shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $PWD/cli/shell/bashrc.d $HOME/.bashrc.d
ln -s $PWD/cli/shell/inputrc $HOME/.inputrc

# Profile
ln -s $PWD/cli/shell/profile $HOME/.profile
