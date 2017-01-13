#!/bin/bash

case "$PAM_TYPE" in
    "auth")
        read passphrase

        sudo -u $PAM_USER -- expect -c " \
            spawn ecryptfs-mount-private; \
            expect \"Enter your login passphrase:\"; \
            send $passphrase\r; \
            interact; \
        "
    ;;

    "close_session")
        # Umount regardless of number of sessions still running to avoid
        # problems with systemd. Apparently, systemd keeps another PAM session
        # to run its (sd-pam) and systemd --user processes.
        # (https://lists.alioth.debian.org/pipermail/pkg-systemd-maintainers/2014-October/004088.html)
        echo 1 | sudo -u $PAM_USER -- tee "/dev/shm/ecryptfs-$PAM_USER-Private"
        sudo -u $PAM_USER -- ecryptfs-umount-private
    ;;
esac
