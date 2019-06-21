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
    # $3: prefix (default: [)
    # $4: suffix (default: ])
    prompt_block() {
        test -z "$1" && return 1
        local prefix="${3:-[}"
        local suffix="${4:-]}"
        local color="\\033[38;5;$2m"
        local reset="\\033[0m"
        echo -n "${prefix}${color}$1${reset}${suffix}"
    }

    prompt_git() {
        local branch=$( ( \
            git symbolic-ref --short HEAD \
         || git rev-parse --short HEAD \
        ) 2>/dev/null )
        prompt_block "$branch" $blue2
    }

    prompt_jobs() {
        jobs -l | while read job; do
            prompt_block "$job" $yellow2 '│ ' '\n'
        done
    }

    prompt_prompt() {
        local bdate=$(prompt_block "$(date +%H:%M)" $purple1)
        local buser=$(prompt_block '\u' $red1)
        local bhost=$(prompt_block '\h' $red2)
        local bpwd=$(prompt_block '\w' $blue1)
        local bvenv=$(prompt_block "$VIRTUAL_ENV" $cyan2)
        PS1="┌${bdate}${buser}${bhost}${bpwd}$(prompt_git)${bvenv}\n"
        PS1="$PS1$(prompt_jobs)"
        PS1="$PS1└> "
    }

    prompt_title() {
        local start_title="\033]0;"
        local end_title="\007"
        echo -ne "${start_title}${USER}@${HOSTNAME}: ${PWD}${end_title}"
    }

    prompt_prompt
    prompt_title

    unset -f prompt_block prompt_git prompt_jobs prompt_prompt prompt_title
}

PROMPT_COMMAND='__prompt'