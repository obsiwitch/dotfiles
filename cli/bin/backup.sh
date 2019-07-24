#!/bin/bash

backup_local() {
    private umount # do not backup plaintext private
    local in=(
        "$HOME"/*
        "$HOME/.dotfiles"
        "$HOME/.dotprivate"
    )
    local out="/run/media/$USER/yayaka_storage/$USER"
    local flags='--archive --delete --prune-empty-dirs --protect-args --progress'
    rsync $flags -- "${in[@]}" "$out"
}

restore_local() {
    local in="/run/media/$USER/yayaka_storage/$USER/"
    local out="$HOME"
    local flags='--archive --protect-args --progress'
    rsync $flags -- "$in" "$out"
}

backup_archive() {
    local in=(
        "$HOME/Private/encrypted"
        "$HOME/Documents"
        "$HOME/.dotfiles"
        "$HOME/.dotprivate"
    )
    local out=$(date +'b%y%m%d.tar')
    local flags='--create --verbose --preserve-permissions --file'
    tar $flags "$out" "${in[@]}"
}

sync_phone() {
    local in=(
        "$HOME/Downloads"
        "$HOME/Music"
        "$HOME/.dotprivate/keepass"
    )
    local out="/run/media/$USER/C2C2-14E6/"
    local flags='--archive --size-only --delete --prune-empty-dirs
        --protect-args --progress'
    rsync $flags -- "${in[@]}" "$out"
}

if [ "$1" == "local" ]; then
    if [ "$2" == "--restore" ]; then
        restore_local
    else
        backup_local
    fi
elif [ "$1" == "archive" ]; then
    backup_archive
elif [ "$1" == "phone" ]; then
    sync_phone
else
    echo 'usage: backup local [--restore]'
    echo '       backup archive'
    echo '       backup phone'
fi
