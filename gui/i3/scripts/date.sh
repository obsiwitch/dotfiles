#!/bin/bash

# Display the calendar for the current month in a notification. The current
# day is highlighted. The default highlighting (ANSI escape sequence) from
# `cal` is replaced by the equivalent in Pango Text Attribute Markup Language.
calendar_notification() {
    calendar="$(
        cal --color='always' \
            | dotreplace - "$(tput rev)"  "<b><span foreground='#F92672'>" \
            | dotreplace - "$(tput rmso)" "</span></b>"
    )"
    notify-send 'Calendar' "$calendar"
}

case $BLOCK_BUTTON in
    1) calendar_notification ;; # left click: display calendar
esac

date '+%d/%m/%Y'
