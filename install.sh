#!/bin/sh

DOTFILES_ROOT=$(pwd)

ln -s $DOTFILES_ROOT/bin/crunchix-disable $HOME/Bin/crunchix-disable
ln -s $DOTFILES_ROOT/bin/crunchix-enable $HOME/Bin/crunchix-enable
ln -s $DOTFILES_ROOT/bin/flactomp3 $HOME/Bin/flactomp3

ln -s $DOTFILES_ROOT/gui/.i3 $HOME/.i3
ln -s $DOTFILES_ROOT/gui/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -s $DOTFILES_ROOT/gui/compton.conf $HOME/.config/compton.conf
ln -s $DOTFILES_ROOT/gui/dunstrc $HOME/.config/dunst/dunstrc

ln -s $DOTFILES_ROOT/shell/.bashrc $HOME/.bashrc
ln -s $DOTFILES_ROOT/shell/.shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $DOTFILES_ROOT/shell/.bashrc.d $HOME/.bashrc.d

ln -s $DOTFILES_ROOT/user/.profile.d $HOME/.profile.d
ln -s $DOTFILES_ROOT/user/.profile $HOME/.profile
ln -s $DOTFILES_ROOT/user/.screenlayout $HOME/.screenlayout
ln -s $DOTFILES_ROOT/user/.inputrc $HOME/.inputrc
ln -s $DOTFILES_ROOT/user/.xinitrc $HOME/.xinitrc
ln -s $DOTFILES_ROOT/user/.xmodmaprc $HOME/.xmodmaprc
ln -s $DOTFILES_ROOT/user/.xsessionrc $HOME/.xsessionrc
ln -s $DOTFILES_ROOT/user/.config/freshwrapper.conf \
      $HOME/.config/freshwrapper.conf
cp $DOTFILES_ROOT/user/.config/xfce4-power-manager.xml \
   $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml

ln -s $DOTFILES_ROOT/user/.gitconfig $HOME/.gitconfig

#ln -s $DOTFILES_ROOT/terminal/sakura.conf $HOME/.config/sakura/sakura.conf
cp $DOTFILES_ROOT/terminal/xfce4.terminalrc \
   $HOME/.config/xfce4/terminal/terminalrc
