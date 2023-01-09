#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
PATH="$sourcep/bin:$PATH"

# wine
wine reg add 'HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations' /v 'Enable' /d 'N' /f
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /v 'UseTakeFocus' /d 'N' /f
