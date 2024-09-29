#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"
sfx1441gp="$dotfilesp/grimoire-sfx1441g"

setup.help() {
    set +o xtrace
    echo 'Arch install script'
    echo
    echo 'references:'
    echo '* https://wiki.archlinux.org/index.php/installation_guide'
    echo '* https://wiki.archlinux.org/index.php/Dm-crypt'
    echo '* https://wiki.archlinux.org/index.php/Partitioning'
    echo
    echo 'prepare:'
    echo '> loadkeys fr'
    echo '> iwctl station <interface> connect <ssid>'
    echo '> pacman -Sy archlinux-keyring pacman-contrib git'
    echo '> git clone https://github.com/obsiwitch/dotfiles.git'
    echo '> dotfiles/user/bin/dotrankmirrors'
    echo
    echo "usage: ${BASH_SOURCE##*/} <cmd>"
    echo 'live:     sys.init'
    echo 'chroot:   sys.conf'
    exit 1
}

setup.sys.init() {
    # partitioning
    local device="/dev/nvme0n1"
    wipefs --all "$device"
    parted "$device" \
        mklabel gpt \
        mkpart 'ESP' fat32 1MiB 513MiB \
        mkpart 'Arch' ext4 513MiB 100% \
        set 1 esp on

    # root partition: dm-crypt + LUKS, ext4
    mkfs.ext4 "${device}p2"
    mount "${device}p2" '/mnt'

    # boot/efi partition
    mkfs.fat -F32 "${device}p1"
    mkdir '/mnt/boot'
    mount "${device}p1" '/mnt/boot'

    # swap file
    dd if='/dev/zero' of='/mnt/swapfile' bs=1M count=12288 status=progress
    chmod 600 '/mnt/swapfile'
    mkswap '/mnt/swapfile'
    swapon '/mnt/swapfile'

    # packages
    sed -e '/^#.*/d' -e '/^$/d' -e 's/^[ \t]*//' \
        "$sourcep/packages/"{core,cli,gui}.pkgs \
        | pacstrap -i '/mnt' -

    # fstab
    genfstab -U '/mnt' > '/mnt/etc/fstab'

    # copy dotfiles
    cp -r "$dotfilesp" '/mnt/root/'
}

setup.sys.conf() {
    # time zone
    ln -sf '/usr/share/zoneinfo/Europe/Paris' '/etc/localtime'

    # localization
    sed -i '/^#en_US.UTF-8/ s/^#//' '/etc/locale.gen'
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'KEYMAP=fr' > /etc/vconsole.conf

    # network
    echo 'grimoire-sd1010' > /etc/hostname

    # unified kernel image
    cp -r "$sfx1441gp/etc/mkinitcpio.d" '/etc'
    mkdir -p '/boot/EFI/BOOT/'
    mkinitcpio --allpresets

    # sudo
    sed -i '/^# %sudo\tALL/ s/^# //' '/etc/sudoers'
    groupadd -f sudo

    # users
    useradd celestia --create-home --groups sudo || [[ "$?" -eq 9 ]]
    passwd --status celestia | awk '$2 != "P" {exit 1}' || passwd celestia

    passwd --status root | awk '$2 != "P" {exit 1}' || passwd root

    # systemd
    if timedatectl > /dev/null; then
        timedatectl set-ntp true
        timedatectl set-local-rtc false
        systemctl enable --now NetworkManager.service
        systemctl enable --now nftables.service
        systemctl enable --now bluetooth.service
        systemctl enable --now sdmap.service || : WARNING
    fi

    # pacman
    cp {"$sfx1441gp",}'/etc/pacman.conf'
}

if [[ "$(type -t "setup.${1:-}")" == 'function' ]]; then
    "setup.$1" "${@:2}"
else
    setup.help
fi
