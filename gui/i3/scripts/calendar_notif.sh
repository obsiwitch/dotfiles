#!/bin/sh

# Display the calendar for the current month in a notification. The current
# day is highlighted.
#
# Note: The `cal` command has highlighting by default, but the format is not
# supported by notifications. Instead, we turn off the default highlighting
# and highlight the current day with html tags (<b></b>).

today=`date +%e`
highlight_today="<b>$today<\/b>" # escape '/' for sed to work correctly

calendar=`ncal -h | sed "s/$today /$highlight_today /g"`

notify-send Calendar "$calendar"
