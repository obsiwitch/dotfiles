#!/bin/sh

normal_background_color="#282828"
normal_foreground_color="#F8F8F2"
selected_background_color="#d6d6d6"
selected_foreground_color="#282828"

dmenu_run -nb $normal_background_color -nf $normal_foreground_color \
          -sb $selected_background_color -sf $selected_foreground_color
