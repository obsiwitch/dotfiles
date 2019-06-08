#!/bin/bash

[[ $- != *i* ]] && return

__prompt() {
    # palette
    local black='0'   ; local grey='8'
    local red1='1'    ; local red2='9'
    local green1='2'  ; local green2='10'
    local yellow1='3' ; local yellow2='11'
    local blue1='4'   ; local blue2='12'
    local purple1='5' ; local purple2='13'
    local cyan1='6'   ; local cyan2='14'
    local white1='7'  ; local white2='15'

    # $1: content
    # $2: color
    prompt.block() {
        test -z "$1" && return 1
        local color="\\033[38;5;$2m"
        local reset="\\033[0m"
        echo -n "[${color}$1${reset}]"
    }

    prompt.git() {
        local branch=$( ( \
            git symbolic-ref --short HEAD \
         || git rev-parse --short HEAD \
        ) 2>/dev/null )
        prompt.block "$branch" $blue2
    }

    prompt.line() {
        local bdate=$(prompt.block "$(date +%H:%M)" $purple1)
        local buser=$(prompt.block '\u' $red1)
        local bhost=$(prompt.block '\h' $red1)
        local bpwd=$(prompt.block '\w' $blue1)
        PS1="┌${bdate}${buser}${bhost}${bpwd}$(prompt.git)\n└> "
    }

    prompt.title() {
        local start_title="\033]0;"
        local end_title="\007"
        echo -ne "${start_title}${USER}@${HOSTNAME}: ${PWD}${end_title}"
    }

    prompt.line
    prompt.title
}

PROMPT_COMMAND='__prompt'
