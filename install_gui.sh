#!/bin/sh

# i3
ln -s $PWD/gui/i3 $HOME/.i3

# GTK
ln -s $PWD/gui/gtkrc-2.0 $HOME/.gtkrc-2.0
ln -s $PWD/gui/gtk-3.0/gtk.css $HOME/.config/gtk-3.0/gtk.css
ln -s $PWD/gui/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini

# X
ln -s $PWD/user/xinitrc $HOME/.xinitrc
ln -s $PWD/user/xmodmaprc $HOME/.xmodmaprc
ln -s $PWD/user/xsessionrc $HOME/.xsessionrc

# Xfce
cp $PWD/user/config/xfce4-power-manager.xml \
   $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
cp $PWD/terminal/xfce4.terminalrc \
   $HOME/.config/xfce4/terminal/terminalrc

# Compositing
ln -s $PWD/gui/compton.conf $HOME/.config/compton.conf

# Notifications
ln -s $PWD/gui/dunstrc $HOME/.config/dunst/dunstrc

# Screen layouts
ln -s $PWD/user/screenlayout $HOME/.screenlayout

# Flash (Firefox)
ln -s $PWD/user/config/freshwrapper.conf \
      $HOME/.config/freshwrapper.conf
