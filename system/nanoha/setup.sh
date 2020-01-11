#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/../..")"
DOTNANOHAP="$DOTFILESP/system/nanoha"
PATH="$DOTFILESP/cli/bin:$PATH"

# kernel modules
dotcp "$DOTNANOHAP/kernel/blacklist.conf" '/etc/modprobe.d/'

# X11
dotcp "$DOTNANOHAP/xorg/"* '/etc/X11/xorg.conf.d/'

# firewall
dotcp "$DOTNANOHAP/security/nftables.conf" '/etc/'

# sudo
dotcp "$DOTNANOHAP/security/sudo_group" '/etc/sudoers.d/group'
chmod 0440 '/etc/sudoers.d/group'
