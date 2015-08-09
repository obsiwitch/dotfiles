#!/bin/sh

# i3
ln -s $PWD/gui/i3 $HOME/.i3

# GTK
ln -s $PWD/gui/gtkrc-2.0 $HOME/.gtkrc-2.0
mkdir -p $HOME/.config/gtk-3.0
ln -s $PWD/gui/gtk-3.0/gtk.css $HOME/.config/gtk-3.0/gtk.css
ln -s $PWD/gui/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini

# X
ln -s $PWD/gui/X/xinitrc $HOME/.xinitrc
ln -s $PWD/gui/X/xmodmaprc $HOME/.xmodmaprc
ln -s $PWD/gui/X/xsessionrc $HOME/.xsessionrc

# Xfce
mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
cp $PWD/gui/Xfce/xfce4-power-manager.xml \
   $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
mkdir -p $HOME/.config/xfce4/terminal
cp $PWD/gui/Xfce/xfce4.terminalrc \
   $HOME/.config/xfce4/terminal/terminalrc

# Compositing
ln -s $PWD/gui/compton.conf $HOME/.config/compton.conf

# Notifications
mkdir -p $HOME/.config/dunst
ln -s $PWD/gui/dunstrc $HOME/.config/dunst/dunstrc

# Screen layouts
ln -s $PWD/user/screenlayout $HOME/.screenlayout

# Flash (Firefox)
ln -s $PWD/user/config/freshwrapper.conf \
      $HOME/.config/freshwrapper.conf
