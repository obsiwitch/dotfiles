#!/bin/bash

backup_local() {
    local in="$HOME/*" # exclude hidden files from $HOME
    local out="/run/media/$USER/yayaka_storage/$USER"
    local flags='--archive --delete --prune-empty-dirs --protect-args --progress'
    private umount # do not backup plaintext private
    rsync "$flags" "$in" "$out"
}

restore_local() {
    local in="/run/media/$USER/yayaka_storage/$USER/"
    local out="$HOME"
    local flags='--archive --protect-args --progress'
    rsync "$flags" "$in" "$out"
}

backup_archive() {
    local in="$HOME/Private/encrypted"
    local out=$(date +'b%y%m%d.tar')
    local flags='--create --verbose --preserve-permissions --file'
    tar "$flags" "$out" "$in"
}

if [ "$1" == "local" ]; then
    if [ "$2" == "--restore" ]; then restore_local
    else backup_local; fi
elif [ "$1" == "archive" ]; then backup_archive
else
    echo 'usage: backup local [--restore]'
    echo '       backup archive'
fi
