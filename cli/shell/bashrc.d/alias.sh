#!/bin/bash

[[ $- != *i* ]] && return

alias ls='ls --group-directories-first --color=auto --human-readable'
alias grep='grep --color=auto'
alias cb='xclip -rmlastnl -selection clipboard'
alias ip='ip -color'

## cdc - Change directory to current one. Fix "unreachable" directory problems
## after unmounting and remounting a filesystem.
alias cdc='cd "$PWD"'
