#!/bin/bash

DOTDIR="$(realpath "$(dirname "$0")/..")"
PATH="$DOTDIR/cli/bin:$PATH"
source dotfail

str="$(dotreplace 'lorem ipsum dolor' 'lorem' 'nya')"
[[ "$str" == 'nya ipsum dolor' ]] || dotfail
str="$(dotreplace '&~"#()[]`_;,!/^$|@+-.*!?' '.*' 'nya')"
[[ "$str" == '&~"#()[]`_;,!/^$|@+-nya!?' ]] || dotfail

exit 0
