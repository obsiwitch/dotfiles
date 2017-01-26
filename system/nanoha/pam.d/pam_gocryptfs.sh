#!/bin/bash

case "$PAM_TYPE" in
    "auth")
        read passphrase

        chmod u+w /home/$PAM_USER/main
        echo $passphrase | /usr/bin/gocryptfs \
                                /home/$PAM_USER/encrypted \
                                /home/$PAM_USER/plaintext
    ;;
esac
