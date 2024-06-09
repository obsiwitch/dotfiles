#!/bin/bash

[[ $- != *i* ]] && return

_fzf_select() {
    local lineleft=${READLINE_LINE:0:$READLINE_POINT}
    local lineright=${READLINE_LINE:$READLINE_POINT}
    local selected=$(
        fd . "$@" --print0 \
        | fzf --reverse --prompt="> ${lineleft}_${lineright} > " \
              --multi --read0 --print0 \
        | xargs -0 --no-run-if-empty printf '%q '
    )
    [[ -z "$selected" ]] && return
    READLINE_LINE="${lineleft}${selected}${lineright}"
    READLINE_POINT=$(( $READLINE_POINT + ${#selected} ))
}
bind -x '"\C-f": _fzf_select "$PWD"'
bind -x '"\C-g": _fzf_select "$HOME"'
