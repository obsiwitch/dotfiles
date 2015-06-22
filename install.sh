#!/bin/sh

DOTFILES_ROOT=$(pwd)

ln -s $DOTFILES_ROOT/gui/.i3 $HOME/.i3

ln -s $DOTFILES_ROOT/shell/.bashrc $HOME/.bashrc
ln -s $DOTFILES_ROOT/shell/.shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $DOTFILES_ROOT/shell/.bashrc.d $HOME/.bashrc.d

ln -s $DOTFILES_ROOT/system/.profile.d $HOME/.profile.d
ln -s $DOTFILES_ROOT/system/.profile $HOME/.profile
ln -s $DOTFILES_ROOT/system/.screenlayout $HOME/.screenlayout
ln -s $DOTFILES_ROOT/system/.inputrc $HOME/.inputrc

ln -s $DOTFILES_ROOT/git/.gitconfig $HOME/.gitconfig
