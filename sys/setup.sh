#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/..")"
DOTSYSP="$DOTFILESP/sys"
PATH="$DOTFILESP/user/bin:$PATH"

setup.help() {
    echo 'Arch install script'
    echo
    echo 'useful external tools:'
    echo '* keymap: loadkeys fr'
    echo '* network: wifi-menu'
    echo '* partition: fdisk cfdisk cgdisk parted mkfs mkswap swapon genfstab'
    echo '* container: arch-chroot systemd-nspawn machinectl'
    echo
    echo "usage: $(basename "$0") <cmd>"
    echo '  provision'
    echo '  configure'
    echo '  bootloader [device]'
}

setup.provision() {
    # kernel modules
    dotcp "$DOTSYSP/kernel/"* '/etc/modprobe.d/'

    # X11
    dotcp "$DOTSYSP/xorg/"* '/etc/X11/xorg.conf.d/'

    # sudo
    dotcp "$DOTSYSP/security/sudo_group" '/etc/sudoers.d/group'
    chmod 0440 '/etc/sudoers.d/group'
}

setup.configure() {
    # time
    timedatectl set-timezone Europe/Paris
    timedatectl set-ntp true
    timedatectl set-local-rtc false

    # locale
    sed -i '/^#en_US.UTF-8/ s/^#//' /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'KEYMAP=fr' > /etc/vconsole.conf

    # network
    echo 'nanoha' > /etc/hostname

    # users
    echo 'root' && passwd root
    groupadd sudo || :
    useradd luna --create-home --groups sudo || :
    echo 'luna' && passwd luna

    # services
    systemctl enable NetworkManager.service
    systemctl enable nftables.service
}

setup.bootloader() {
    if [[ -d /sys/firmware/efi ]]; then
        grub-install --target='x86_64-efi' --efi-directory='/boot/efi'
    else
        [[ -b "${1:-}" ]] || doterr 'specify a block device'
        grub-install --target='i386-pc' "$1"
    fi
    grub-mkconfig -o /boot/grub/grub.cfg
}

if [[ "$(type -t "setup.${1:-}")" == 'function' ]]; then
    "setup.$1" "${@:2}"
else
    setup.help
    exit 1
fi
