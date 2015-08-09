#!/bin/sh

ln -s $PWD/bin/crunchix-disable $HOME/Bin/crunchix-disable
ln -s $PWD/bin/crunchix-enable $HOME/Bin/crunchix-enable
ln -s $PWD/bin/flactomp3 $HOME/Bin/flactomp3

ln -s $PWD/gui/i3 $HOME/.i3
ln -s $PWD/gui/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -s $PWD/gui/gtk-3.0/gtk.css $HOME/.config/gtk-3.0/gtk.css
ln -s $PWD/gui/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini
ln -s $PWD/gui/compton.conf $HOME/.config/compton.conf
ln -s $PWD/gui/dunstrc $HOME/.config/dunst/dunstrc

ln -s $PWD/shell/bashrc $HOME/.bashrc
ln -s $PWD/shell/shell_prompt.sh $HOME/.shell_prompt.sh
ln -s $PWD/shell/bashrc.d $HOME/.bashrc.d

ln -s $PWD/user/profile.d $HOME/.profile.d
ln -s $PWD/user/profile $HOME/.profile
ln -s $PWD/user/screenlayout $HOME/.screenlayout
ln -s $PWD/user/inputrc $HOME/.inputrc
ln -s $PWD/user/xinitrc $HOME/.xinitrc
ln -s $PWD/user/xmodmaprc $HOME/.xmodmaprc
ln -s $PWD/user/xsessionrc $HOME/.xsessionrc
ln -s $PWD/user/config/freshwrapper.conf \
      $HOME/.config/freshwrapper.conf
cp $PWD/user/config/xfce4-power-manager.xml \
   $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml

ln -s $PWD/user/gitconfig $HOME/.gitconfig

cp $PWD/terminal/xfce4.terminalrc \
   $HOME/.config/xfce4/terminal/terminalrc
