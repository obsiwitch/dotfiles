#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/..")"
PATH="$DOTFILESP/user/bin:$PATH"
source dotfail

test_cbtxt() {
    shellcheck "$DOTFILESP/user/bin/cbtxt"

    local str='Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
    cbtxt "$str"
    [[ "$(xclip -selection clipboard -out)" == "$str" ]] || dotfail
}

test_cbfiles() {
    shellcheck "$DOTFILESP/user/bin/cbfiles"

    local str; str="file://$(realpath "$0")"
    cbfiles "$0"
    [[ "$(xclip -selection clipboard -out)" \
        == "$(echo -e "copy\n$str")" ]] || dotfail
}

test_cbtxt
test_cbfiles

exit 0
