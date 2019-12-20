#!/bin/bash

PATH="$PWD/cli/bin:$PATH"
source dotfail

tmpdir=$(mktemp -d)
trap "rm -r $tmpdir" EXIT

echo 'a' > "$tmpdir/a"
dotrename "$tmpdir/a"
[[ -f "$tmpdir/3f786850e387550fdab836ed7e6dc881de23001b" ]] || dotfail

echo 'b' > "$tmpdir/b.b"
dotrename "$tmpdir/b.b"
[[ -f "$tmpdir/89e6c98d92887913cadf06b2adb97f26cde4849b.b" ]] || dotfail

echo 'c' > "$tmpdir/c.c.c"
dotrename "$tmpdir/c.c.c"
[[ -f "$tmpdir/2b66fd261ee5c6cfc8de7fa466bab600bcfe4f69.c.c" ]] || dotfail

longstr=$(printf '%*s' 240 | tr ' ' 'd')
echo 'c' > "$tmpdir/d.$longstr"
dotrename "$tmpdir/d.$longstr" 2>/dev/null && dotfail
[[ -f "$tmpdir/d.$longstr" ]] || dotfail
