#!/bin/sh

# i3
rm $HOME/.i3

# GTK
rm $HOME/.gtkrc-2.0
rm $HOME/.config/gtk-3.0/gtk.css
rm $HOME/.config/gtk-3.0/settings.ini

# Xfce
rm $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml

# Thunar
rm $HOME/.config/Thunar/uca.xml
rm $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

# Notifications
rm $HOME/.config/dunst/dunstrc

# Screen layouts
rm $HOME/.screenlayout

# X
rm $HOME/.Xresources
rm $HOME/.xinitrc

# Qt
rm $HOME/.config/Trolltech.conf

# xdg
rm $HOME/.config/user-dirs.conf
