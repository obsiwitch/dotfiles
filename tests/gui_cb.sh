#!/bin/bash

PATH="$PWD/cli/bin:$PATH"
source dotfail

test_cbtxt() {
    shellcheck 'gui/bin/cbtxt'

    local str='Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
    cbtxt "$str"
    [[ "$(xclip -selection clipboard -out)" == "$str" ]] || dotfail
}

test_cbfiles() {
    shellcheck 'gui/bin/cbfiles'

    local str="file://$PWD/$0"
    cbfiles "$0"
    [[ "$(xclip -selection clipboard -out)" == "$str" ]] || dotfail
}

test_cbtxt
test_cbfiles

exit 0
