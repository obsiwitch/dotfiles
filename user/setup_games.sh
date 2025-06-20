#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$sourcep/bin:$PATH"

# retroarch
cp -r "$sourcep/retroarch" "$HOME/.config/"
