#!/bin/bash

encdir="$HOME/Private/encrypted"
plaindir="$HOME/Private/plaintext"

# Mount encrypted directory in plaintext directory.
private_mount() {
    chmod u+w "$plaindir"
    gocryptfs "$encdir" "$plaindir"
}

# Unmount encrypted directory and prevent files being written in the now empty
# plaintext directory (mountpoint).
private_umount() {
    fusermount -zu "$plaindir"
    chmod u-w "$plaindir"
    pkill gocryptfs
}

if   [ "$1" == "mount"  ]; then private_mount
elif [ "$1" == "umount" ]; then private_umount
else echo 'usage: private <mount | umount>'; fi
