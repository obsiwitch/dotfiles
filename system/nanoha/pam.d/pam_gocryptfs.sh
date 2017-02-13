#!/bin/bash

case "$PAM_TYPE" in
    "auth")
        read passphrase

        chmod u+w /home/$PAM_USER/Private/plaintext
        echo $passphrase | /usr/bin/gocryptfs \
                                /home/$PAM_USER/Private/encrypted \
                                /home/$PAM_USER/Private/plaintext
    ;;
esac
