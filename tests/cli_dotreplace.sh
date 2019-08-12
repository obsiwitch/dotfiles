#!/bin/bash

PATH="$PWD/cli/bin:$PATH"
source dotfail

shellcheck 'cli/bin/dotinarray'

str="$(dotreplace 'lorem ipsum dolor' 'lorem' 'nya')"
[[ "$str" == 'nya ipsum dolor' ]] || dotfail
str="$(dotreplace '&~"#()[]`_;,!/^$|@+-.*!?' '.*' 'nya')"
[[ "$str" == '&~"#()[]`_;,!/^$|@+-nya!?' ]] || dotfail

exit 0
