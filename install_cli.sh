#!/bin/sh

# Bin
mkdir -p $HOME/Bin
ln -s $PWD/bin/crunchix-disable $HOME/Bin/crunchix-disable
ln -s $PWD/bin/crunchix-enable $HOME/Bin/crunchix-enable
ln -s $PWD/bin/flactomp3 $HOME/Bin/flactomp3

# Bash
ln -s $PWD/shell/bashrc $HOME/.bashrc
ln -s $PWD/shell/shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $PWD/shell/bashrc.d $HOME/.bashrc.d
ln -s $PWD/user/inputrc $HOME/.inputrc

# Profile
ln -s $PWD/user/profile.d $HOME/.profile.d
ln -s $PWD/user/profile $HOME/.profile
