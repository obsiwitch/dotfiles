#!/bin/bash

set -o errexit -o nounset -o xtrace

gp_dotfiles="$(realpath "${BASH_SOURCE%/*}/..")"
gp_dotarchiso="$gp_dotfiles/archiso"
gp_build="$gp_dotfiles/build"
PATH="$gp_dotfiles/user/bin:$PATH"

# Prepare profile
gp_profile="$gp_dotarchiso/releng"
gp_build_profile="$gp_build/releng"
mkdir -p "$gp_build_profile"
cp -r '/usr/share/archiso/configs/releng/.' "$gp_build_profile"
cat "$gp_profile/airootfs/etc/mkinitcpio.conf.part" \
    >> "$gp_build_profile/airootfs/etc/mkinitcpio.conf"
cat "$gp_profile/packages.x86_64.part" >> "$gp_build_profile/packages.x86_64"
cp "$gp_profile/profiledef.sh" "$gp_build_profile"
git clone "$gp_dotfiles" "$gp_build_profile/airootfs/root/dotfiles"

# Create iso
gp_build_mkarchiso="$gp_build/mkarchiso"
mkdir -p "$gp_build_mkarchiso"
sudo mkarchiso -v -w "$gp_build_mkarchiso" -o "$gp_build" "$gp_build_profile"

# Clean
## "Warning: If mkarchiso is interrupted, run findmnt(8) to make sure there are
## no mount binds before deleting it - otherwise, you may lose data."
## Source: https://wiki.archlinux.org/index.php/Archiso#Removal_of_work_directory
## Note: mkarchiso seems to correctly unmount everything when manually sending
## it a SIGINT signal. Check as a precautionary measure.
if findmnt | grep "$gp_dotfiles"; then exit 1; fi
sudo rm -rf "$gp_build_mkarchiso"
rm -rf "$gp_build_profile"
