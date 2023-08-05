#!/bin/bash

set -o errexit -o nounset -o xtrace

# wine
winetricks settings mimeassoc=off # disable exporting MIME-type file associations to the native desktop
winetricks settings isolate_home # remove links to home
winetricks dlls dxvk
winetricks dlls corefonts
winetricks settings alldlls=default # remove all DLL overrides
