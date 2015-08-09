#!/bin/sh

# i3
rm $HOME/.i3

# GTK
rm $HOME/.gtkrc-2.0
rm $HOME/.config/gtk-3.0/gtk.css
rm $HOME/.config/gtk-3.0/settings.ini

# X
rm $HOME/.xinitrc
rm $HOME/.xmodmaprc
rm $HOME/.xsessionrc

# Xfce
rm $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
rm $HOME/.config/xfce4/terminal/terminalrc

# Compositing
rm $HOME/.config/compton.conf

# Notifications
rm $HOME/.config/dunst/dunstrc

# Screen layouts
rm $HOME/.screenlayout

# Flash (Firefox)
rm $HOME/.config/freshwrapper.conf
