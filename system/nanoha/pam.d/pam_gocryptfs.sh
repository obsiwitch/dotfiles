#!/bin/bash

case "$PAM_TYPE" in
    "auth")
        read passphrase

        chmod u+w /home/$PAM_USER
        echo $passphrase | /usr/bin/gocryptfs -allow_other \
                                /home/$PAM_USER.encrypted \
                                /home/$PAM_USER
    ;;
esac
