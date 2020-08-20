#!/bin/bash

[[ $- != *i* ]] && return

ls() { /bin/ls --group-directories-first --color='auto' --human-readable \
               --time-style='+%y-%m-%d|%H:%M' "$@"; }

alias grep='grep --color=auto'
alias ip='ip -color'
alias diff='diff --unified --color=auto'

## cdc - Change directory to current one. Fix "unreachable" directory problems
## after unmounting and remounting a filesystem.
alias cdc='cd "$PWD"'
