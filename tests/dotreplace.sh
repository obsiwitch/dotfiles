#!/bin/bash

set -o errexit -o nounset -o xtrace

DOTFILESP="$(realpath "$(dirname "$0")/..")"
PATH="$DOTFILESP/user/bin:$PATH"

str="$(dotreplace 'lorem ipsum dolor' 'lorem' 'nya')"
[[ "$str" == 'nya ipsum dolor' ]]
str="$(dotreplace '&~"#()[]`_;,!/^$|@+-.*!?' '.*' 'nya')"
[[ "$str" == '&~"#()[]`_;,!/^$|@+-nya!?' ]]
