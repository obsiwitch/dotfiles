#!/bin/sh

# Bin
mkdir -p $HOME/Bin
ln -s $PWD/cli/bin/crunchix-disable $HOME/Bin/crunchix-disable
ln -s $PWD/cli/bin/crunchix-enable $HOME/Bin/crunchix-enable
ln -s $PWD/cli/bin/flactomp3 $HOME/Bin/flactomp3

# Bash
ln -s $PWD/cli/shell/bashrc $HOME/.bashrc
ln -s $PWD/cli/shell/shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $PWD/cli/shell/bashrc.d $HOME/.bashrc.d
ln -s $PWD/cli/shell/inputrc $HOME/.inputrc

# Profile
ln -s $PWD/cli/profile.d $HOME/.profile.d
ln -s $PWD/cli/profile $HOME/.profile
