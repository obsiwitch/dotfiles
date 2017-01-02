#!/bin/sh

artist=`cmus-remote -C 'format_print "%a"'`
album=`cmus-remote -C 'format_print "%l"'`
title=`cmus-remote -C 'format_print "%t"'`

notify-send cmus "$title\n$album\n$artist"
