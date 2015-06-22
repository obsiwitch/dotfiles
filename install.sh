#!/bin/sh

DOTFILES_ROOT=$(pwd)

ln -s $DOTFILES_ROOT/gui/.i3 $HOME/.i3

ln -s $DOTFILES_ROOT/shell/.bashrc $HOME/.bashrc
ln -s $DOTFILES_ROOT/shell/.bashrc.d $HOME/.bashrc.d
