#!/bin/bash

[[ $- != *i* ]] && return

source /usr/share/git/completion/git-prompt.sh

__prompt() {
    local exit="$?"

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
    # $3: prefix (default: none)
    # $4: suffix (default: none)
    # see tput(1), terminfo(5) and infocmp(1M)
    prompt_block() {
        test -z "$1" && return 1
        local prefix="${3}"
        local suffix="${4}"
        local color; color="\[$(tput setaf "$2")\]"
        local reset; reset="\[$(tput sgr0)\]"
        echo -n "${prefix}${color}$1${reset}${suffix}"
    }

    prompt_git() {
        local status; status="$(
            GIT_PS1_SHOWDIRTYSTATE=1 \
            GIT_PS1_SHOWSTASHSTATE=1 \
            GIT_PS1_SHOWUNTRACKEDFILES=1 \
            GIT_PS1_SHOWUPSTREAM='auto' \
            __git_ps1 '%s'
        )"
        prompt_block "$status" $blue2 '[' ']'
    }

    prompt_jobs() {
        jobs -l | tr --squeeze-repeats ' ' | while read -r job; do
            prompt_block "$job" $yellow2 '│ ' '\n'
        done
    }

    # $1: content
    prompt_status() {
        if [[ $exit -ne 0 ]]; then
            prompt_block "[↵$exit]" "$red2"
        fi
    }

    prompt_prompt() {
        local buser; buser=$(prompt_block '\u' $red1 '[' ']')
        local bhost; bhost=$(prompt_block '\h' $red2 '[' ']')
        local bpwd; bpwd=$(prompt_block '\w' $blue1 '[' ']')
        PS1="$(prompt_status)${buser}${bhost}${bpwd}$(prompt_git)\n"
        PS1="$PS1$(prompt_jobs)"
        PS1="$PS1└> "
    }

    prompt_title() {
        tput hs && echo -n "$(tput tsl)${USER}@${HOSTNAME}: ${PWD}$(tput fsl)"
    }

    prompt_prompt
    prompt_title

    unset -f prompt_block prompt_git prompt_jobs prompt_status \
        prompt_prompt prompt_title
}

PROMPT_COMMAND='__prompt'
