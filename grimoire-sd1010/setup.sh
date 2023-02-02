#!/bin/bash

set -o errexit -o nounset -o xtrace

sourcep="$(realpath "${BASH_SOURCE%/*}")"
dotfilesp="$(realpath "${BASH_SOURCE%/*}/..")"

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
    echo '> iwctl station $iface connect $ssid'
    echo '> pacman -Sy archlinux-keyring pacman-contrib git'
    echo '> git clone https://github.com/obsiwitch/dotfiles.git'
    echo '> dotfiles/user/bin/dotrankmirrors'
    echo
    echo "usage: ${BASH_SOURCE##*/} <cmd>"
    echo 'live:     sys.init <device>'
    echo 'chroot:   sys.conf'
    exit 1
}

setup.sys.init() {
    # partitioning
    local device="$1"
    wipefs --all "$device"
    parted "$device" \
        mklabel gpt \
        mkpart 'ESP' fat32 1MiB 513MiB \
        mkpart 'Arch' ext4 513MiB 100% \
        set 1 esp on \

    # root partition: dm-crypt + LUKS, ext4
    cryptsetup --verify-passphrase luksFormat "${device}2"
    cryptsetup open "${device}2" 'cryptroot'
    mkfs.ext4 '/dev/mapper/cryptroot'
    mount '/dev/mapper/cryptroot' '/mnt'

    # boot/efi partition
    mkfs.fat -F32 "${device}1"
    mkdir '/mnt/boot'
    mount "${device}1" '/mnt/boot'

    # swap file
    dd if='/dev/zero' of='/mnt/swapfile' bs=1M count=12288 status=progress
    chmod 600 '/mnt/swapfile'
    mkswap '/mnt/swapfile'
    swapon '/mnt/swapfile'

    # packages
    sed -e '/^#.*/d' -e '/^$/d' "$sourcep/packages/"{cli,gui}.pkgs \
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

    # kernel modules
    cp -r "$sourcep/etc/modprobe.d" '/etc'

    # bootloader
    bootctl install

    # unified kernel image (requires: /etc/vconsole.conf)
    local root_uuid crypt_uuid resume_offset
    root_uuid="$(lsblk --nodeps --noheadings --output='UUID' '/dev/mapper/cryptroot')"
    crypt_uuid="$(lsblk --nodeps --noheadings --output='UUID' '/dev/nvme0n1p2')"
    resume_offset="$(filefrag -v '/swapfile' | awk '/^ *0:/ {print $4}')"
    tee {"$sourcep",}'/etc/kernel/cmdline' \
        <<< "root=UUID=${root_uuid} \
             cryptdevice=UUID=${crypt_uuid}:cryptroot \
             resume=/dev/mapper/cryptroot resume_offset=${resume_offset}"
    cp {"$sourcep",}'/etc/mkinitcpio.d/linux.preset'
    cp {"$sourcep",}'/etc/mkinitcpio.conf'
    mkinitcpio --allpresets

    # sudo
    sed -i '/^# %sudo\tALL/ s/^# //' '/etc/sudoers'
    groupadd -f sudo

    # users
    useradd luna --create-home --groups sudo || [[ "$?" -eq 9 ]]
    passwd --status luna | awk '$2 != "P" {exit 1}' || passwd luna

    useradd celestia --create-home || [[ "$?" -eq 9 ]]
    passwd --status celestia | awk '$2 != "P" {exit 1}' || passwd celestia

    passwd --status root | awk '$2 != "P" {exit 1}' || passwd root

    # systemd
    cp -r "$sourcep/etc/systemd" '/etc'
    cp -r "$sourcep/etc/tmpfiles.d" '/etc'
    if timedatectl > /dev/null; then
        timedatectl set-ntp true
        timedatectl set-local-rtc false
        systemctl enable --now NetworkManager.service
        systemctl enable --now nftables.service
        systemctl enable --now cups.service
        systemctl enable --now sdmap.service || : WARNING
    fi

    # pacman
    cp {"$sourcep",}'/etc/pacman.conf'

    # cups
    cp -r "$sourcep/etc/cups" '/etc'
    chmod 640 '/etc/cups/cupsd.conf'
    chown root:cups '/etc/cups/cupsd.conf'

    # udev
    cp -r "$sourcep/etc/udev" '/etc'
}

if [[ "$(type -t "setup.${1:-}")" == 'function' ]]; then
    "setup.$1" "${@:2}"
else
    setup.help
fi
