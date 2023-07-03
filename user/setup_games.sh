#!/bin/bash

set -o errexit -o nounset -o xtrace

# wine
wine reg add 'HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations' /v 'Enable' /d 'N' /f
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /v 'UseTakeFocus' /d 'N' /f
winetricks isolate_home
winetricks dlls dxvk
winetricks dlls corefonts
