#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/..")"
PATH="$DOTFILESP/user/bin:$PATH"
source dotfail

test_cbt() {
    shellcheck "$DOTFILESP/user/bin/cbt"

    local str='Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
    cbt "$str"
    [[ "$(xclip -selection clipboard -out)" == "$str" ]] || dotfail
}

test_cbf() {
    shellcheck "$DOTFILESP/user/bin/cbf"

    local str; str="file://$(realpath "$0")"
    cbf "$0"
    [[ "$(xclip -selection clipboard -out)" \
        == "$(echo -e "copy\n$str")" ]] || dotfail
}

test_cbt
test_cbf

exit 0
