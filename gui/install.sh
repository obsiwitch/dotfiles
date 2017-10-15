#!/bin/sh

$PWD/gui/remove.sh

# i3
ln -s $PWD/gui/i3 $HOME/.i3

# GTK
ln -s $PWD/gui/gtk/gtk-2.0/gtkrc-2.0 $HOME/.gtkrc-2.0
mkdir -p $HOME/.config/gtk-3.0
ln -s $PWD/gui/gtk/gtk-3.0/gtk.css $HOME/.config/gtk-3.0/gtk.css
ln -s $PWD/gui/gtk/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini

# pluma
mkdir -p $HOME/.local/share
ln -s $PWD/gui/gtksourceview $HOME/.local/share/gtksourceview-3.0
mkdir -p $HOME/.config/pluma
ln -s $PWD/gui/pluma/tools $HOME/.config/pluma/tools

# Xfce
mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
cp $PWD/gui/Xfce/xfce4-power-manager.xml \
   $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml

# Thunar
mkdir -p $HOME/.config/Thunar
cp $PWD/gui/thunar/uca.xml $HOME/.config/Thunar/uca.xml
cp $PWD/gui/thunar/thunar.xml \
   $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

# Notifications
mkdir -p $HOME/.config/dunst
ln -s $PWD/gui/dunstrc $HOME/.config/dunst/dunstrc

# Screen layouts
ln -s $PWD/gui/screenlayout $HOME/.screenlayout

# Terminal
ln -s $PWD/gui/X/Xresources $HOME/.Xresources

# Qt
cp $PWD/gui/Qt/Trolltech.conf $HOME/.config/Trolltech.conf

# xdg
ln -s $PWD/gui/xdg/user-dirs.conf $HOME/.config/user-dirs.conf
