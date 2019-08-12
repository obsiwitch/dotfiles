#!/bin/bash

PATH="$PWD/cli/bin:$PATH"
source dotfail

shellcheck 'cli/bin/dotinarray'

array=( miaou meow nya )
dotinarray miaou "${array[@]}" || dotfail
dotinarray meow "${array[@]}" || dotfail
dotinarray nya "${array[@]}" || dotfail
dotinarray awoo "${array[@]}" && dotfail

exit 0
