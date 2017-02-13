#!/bin/bash

case "$PAM_TYPE" in
    "auth")
        read passphrase

        chmod u+w /home/$PAM_USER/Private
        echo $passphrase | /usr/bin/gocryptfs \
                                /home/$PAM_USER/.private \
                                /home/$PAM_USER/Private
    ;;
esac
