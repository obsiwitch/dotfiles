#!/bin/sh

# Display the calendar for the current month in a notification. The current
# day is highlighted.
#
# Note: The `cal` command has highlighting by default, but the format is not
# supported by notifications. Instead, we turn off the default highlighting
# and highlight the current day with Pango Text Attribute Markup Language
# (<https://developer.gnome.org/pango/stable/PangoMarkupFormat.html>).
calendar_notification() {

    today=`date +%e`
    highlight_today="<b><span foreground='#F92672'>$today<\/span><\/b>"

    calendar=`cal | sed "s/$today /$highlight_today /g"`

    notify-send Calendar "$calendar"
}

case $BLOCK_BUTTON in
    1) calendar_notification ;; # left click, display calendar
esac

date '+%d/%m/%Y - %H:%M'
