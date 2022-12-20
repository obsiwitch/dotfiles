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
    echo "usage: ${BASH_SOURCE##*/} <cmd>"
    echo 'live:     live.conf'
    echo 'live:     sys.init <device>'
    echo 'chroot:   sys.conf'
    exit 1
}

setup.live.conf() {
    # loadkeys fr
    # iwctl station $iface connect $ssid
    # pacman -Sy archlinux-keyring pacman-contrib git grub efibootmgr
    # git clone https://github.com/obsiwitch/dotfiles.git
    dotrankmirrors
}

setup.sys.init() {
    # partitioning
    local device="$1"
    wipefs --all "$device"
    parted "$device" \
        mklabel gpt \
        mkpart 'ESP' fat32 1MiB 513MiB \
        mkpart 'Arch' ext4 513MiB 100%

    # root partition: dm-crypt + LUKS, ext4
    cryptsetup --verify-passphrase luksFormat "${device}2"
    cryptsetup open "${device}2" 'cryptroot'
    mkfs.ext4 '/dev/mapper/cryptroot'
    mount '/dev/mapper/cryptroot' '/mnt'

    # boot partition
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

    # bootloader
    grub-install --target='x86_64-efi' \
        --efi-directory='/mnt/boot' \
        --boot-directory='/mnt/boot'

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

    # initramfs (requires: /etc/vconsole.conf)
    cp {"$sourcep",}'/etc/mkinitcpio.conf'
    mkinitcpio --allpresets

    # bootloader
    crypt_uuid="$(lsblk --nodeps --noheadings --output='UUID' '/dev/nvme0n1p2')" \
    resume_offset="$(filefrag -v '/swapfile' | awk '/^ *0:/ {print $4}')" \
        envsubst < "$sourcep/etc/default/grub.tpl" \
            | tee {"$sourcep",}'/etc/default/grub' > /dev/null
    grub-mkconfig -o '/boot/grub/grub.cfg'

    # sudo
    sed -i '/^# %sudo\tALL/ s/^# //' '/etc/sudoers'
    groupadd -f sudo

    # users
    useradd luna --create-home --groups sudo || [[ "$?" -eq 9 ]]
    passwd --status luna | awk '$2 != "P" {exit 1}' || passwd luna

    useradd celestia --create-home || [[ "$?" -eq 9 ]]
    passwd --status celestia | awk '$2 != "P" {exit 1}' || passwd celestia

    useradd build --create-home  || [[ "$?" -eq 9 ]]

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
