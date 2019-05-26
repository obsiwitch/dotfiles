#!/bin/bash

function cdf() {
    local findcmd='fd --type d'
    [[ "$*" == *-a* ]] && findcmd="$findcmd
        --hidden
        --exclude .git
        --exclude .cache
        --exclude __pycache__
    "
    local path=$($findcmd | fzf --no-multi --exit-0)
    [[ ! -z "$path" ]] && cd "$path"
}
