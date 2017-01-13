#!/bin/sh

# i3
ln -s $PWD/gui/i3 $HOME/.i3

# Nemo
ln -s $PWD/gui/nemo/actions \
      $HOME/.local/share/nemo/actions
## Open in terminal action
gsettings set org.cinnamon.desktop.default-applications.terminal exec urxvt
## do not manage desktop
gsettings set org.nemo.desktop show-desktop-icons false

# GTK
ln -s $PWD/gui/gtk/gtk-2.0/gtkrc-2.0 $HOME/.gtkrc-2.0
mkdir -p $HOME/.config/gtk-3.0
ln -s $PWD/gui/gtk/gtk-3.0/gtk.css $HOME/.config/gtk-3.0/gtk.css
ln -s $PWD/gui/gtk/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini

# Xfce
mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
cp $PWD/gui/Xfce/xfce4-power-manager.xml \
   $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml

# Notifications
mkdir -p $HOME/.config/dunst
ln -s $PWD/gui/dunstrc $HOME/.config/dunst/dunstrc

# Screen layouts
ln -s $PWD/gui/screenlayout $HOME/.screenlayout

# Atom
mkdir -p $HOME/.atom
ln -s $PWD/gui/atom/* $HOME/.atom/

# Terminal
ln -s $PWD/gui/X/Xresources $HOME/.Xresources

# Qt
cp $PWD/gui/Qt/Trolltech.conf $HOME/.config/Trolltech.conf
