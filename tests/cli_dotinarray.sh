#!/bin/bash

DOTDIR="$(realpath "$(dirname "$0")/..")"
PATH="$DOTDIR/cli/bin:$PATH"
source dotfail

shellcheck "$DOTDIR/cli/bin/dotinarray"

array=( miaou meow nya )
dotinarray miaou "${array[@]}" || dotfail
dotinarray meow "${array[@]}" || dotfail
dotinarray nya "${array[@]}" || dotfail
dotinarray awoo "${array[@]}" && dotfail

exit 0
