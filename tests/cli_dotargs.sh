#!/bin/bash

DOTDIR="$(realpath "$(dirname "$0")/..")"
PATH="$DOTDIR/cli/bin:$PATH"
source dotfail

shellcheck --exclude='SC2034' "$DOTDIR/cli/bin/dotargs"

eval "$(dotargs a -l=orem b -i c --dolor=sit d --amet e)"
out1='declare -a posargs=([0]="a" [1]="b" [2]="c" [3]="d" [4]="e")'
out2='declare -a optargs=([0]="-l=orem" [1]="-i" [2]="--dolor=sit" [3]="--amet")'
out3='declare -A kwargs=([--dolor]="sit" [-l]="orem" [-i]="-i" [--amet]="--amet" )'
[[ "$(declare -p posargs)" == "$out1" ]] || dotfail
[[ "$(declare -p optargs)" == "$out2" ]] || dotfail
[[ "$(declare -p kwargs)" == "$out3" ]] || dotfail

exit 0
