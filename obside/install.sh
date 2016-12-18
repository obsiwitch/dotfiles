#!/bin/sh

# Bin
mkdir -p $HOME/Bin
ln -s $PWD/obside/bin/* $HOME/Bin/

# git
ln -s $PWD/obside/gitconfig $HOME/.gitconfig
