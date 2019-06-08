#!/bin/bash

[[ $- != *i* ]] && return

# Readline completion.
# https://unix.stackexchange.com/questions/213799/can-bash-write-to-its-own-input-stream
function _rl_complete() {
    bind '"\e[0n": complete'
    printf '\e[5n'
}

# Fuzzy completion on trigger sequence '@' using fzf, else use readline's
# completion. This function should be bound to a keysequence using `bind -x`.
# @[opts][:path]<keyseq>
# opts:
#   d - directories
#   a - include hidden paths
# examples:
#   cd @d<keyseq>
#   cd @da:..<keyseq>
#   vim @<keyseq>
function _fzf_complete() {
    local words=( ${READLINE_LINE:0:$READLINE_POINT} )
    local remainder=( ${READLINE_LINE:$READLINE_POINT} )
    [[ -n $words ]] && {
        local trigger=( ${words[-1]/:/ } )
        local opts=${trigger[0]}
        local path=${trigger[1]}
    }

    if [[ "${opts:0:1}" != '@' ]]; then
        _rl_complete
        return
    fi

    local findcmd='fd . --print0'
    [[ -n "$path" ]] && findcmd="$findcmd $path"
    [[ "$opts" == *d* ]] && findcmd="$findcmd --type d"
    [[ "$opts" == *a* ]] && findcmd="$findcmd
        --hidden
        --exclude .git
        --exclude .cache
        --exclude __pycache__
    "
    local selected=$(
        $findcmd | fzf --reverse --multi --read0 --print0 --exit-0 \
                 | xargs -0 --no-run-if-empty printf '%q '
    )
    [[ -z "$selected" ]] && return
    unset 'words[-1]'

    READLINE_LINE="${words[*]} ${selected}${remainder[*]}"
    READLINE_POINT=$(( $READLINE_POINT + ${#selected} ))
}
bind -x '"\C-i": "_fzf_complete"'

## Completion fallback for commands handled by bash-completion _longopt and _cd.
## Restore glob completion. See unmerged pull-request [Handle ambiguous globs
## gracefully #77](https://github.com/scop/bash-completion/pull/77).
compopt -o bashdefault ls cd
