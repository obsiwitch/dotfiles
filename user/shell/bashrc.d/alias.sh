#!/bin/bash

[[ $- != *i* ]] && return

ls() { /bin/ls --group-directories-first --color='auto' --human-readable \
               --time-style='+%y-%m-%d|%H:%M' "$@"; }

alias grep='grep --color=auto'
alias ip='ip -color'
alias diff='diff --unified --color=auto'
alias icat='kitty +kitten icat'
alias manh='man --html=links'
