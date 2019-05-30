#!/bin/bash

(for filePath in "$@"; do
    if [[ -d $filePath ]]; then continue; fi

    dirPath=$(dirname "$filePath")
    fileExt=$(echo "$filePath" | awk -F . '{print $NF}')
    hash=$(sha1sum "$filePath" | cut -d' ' -f1)

    mv "$filePath" "$dirPath/$hash.$fileExt"
done)
