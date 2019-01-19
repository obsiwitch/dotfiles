#!/bin/sh

# bin
for bin in $PWD/gui/bin/*; do
    rm $HOME/Applications/`basename $bin`
done

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

# X
rm $HOME/.Xresources
rm $HOME/.xinitrc

# Qt
rm $HOME/.config/Trolltech.conf

# xdg
rm $HOME/.config/user-dirs.conf

# cache
rm -rf $HOME/.cache/thumbnails
rm -rf $HOME/.thumbnails
rm $HOME/.python_history
