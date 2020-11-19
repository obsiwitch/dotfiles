#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/..")"
DOTSYSP="$DOTFILESP/sys"
PATH="$DOTFILESP/user/bin:$PATH"

setup.help() {
    echo 'Arch install script'
    echo
    echo 'useful external tools:'
    echo '* partition: cfdisk cgdisk parted mkfs mkswap swapon genfstab'
    echo '* container: arch-chroot systemd-nspawn machinectl'
    echo
    echo "usage: $(basename "$0") <cmd>"
    echo '  live.conf'
    echo '  sys.init <root partition> <boot partition>'
    echo '  sys.conf'
    echo '  sys.systemd'
}

setup.live.conf() {
    # loadkeys fr
    # iwctl
    # pacman -Sy archlinux-keyring pacman-contrib git
    # git clone https://gitlab.com/Obsidienne/dotfiles.git
    dotrankmirrors
    cfdisk  # gpt: EFI system (512MiB), Linux filesystem (remainder)
}

setup.sys.init() {
    # root partition: dm-crypt + LUKS, ext4
    cryptsetup --verify-passphrase luksFormat "$1"
    cryptsetup open "$1" 'cryptroot'
    mkfs.ext4 '/dev/mapper/cryptroot'
    mount '/dev/mapper/cryptroot' '/mnt'

    # boot partition
    mkfs.fat -F32 "$2"
    mkdir '/mnt/boot'
    mount "$2" '/mnt/boot'

    # swap file
    dd if='/dev/zero' of='/mnt/swapfile' bs=1M count=8192 status=progress
    chmod 600 '/mnt/swapfile'
    mkswap '/mnt/swapfile'
    swapon '/mnt/swapfile'

    # packages
    pacstrap -i '/mnt' base base-devel linux linux-firmware intel-ucode \
        amd-ucode grub efibootmgr archiso pacman-contrib networkmanager \
        nftables

    # fstab
    genfstab -U '/mnt' > '/mnt/etc/fstab'

    # copy dotfiles
    cp -r "$DOTFILESP" '/mnt/root/'
}

setup.sys.conf() {
    # kernel modules
    cp -r "$DOTSYSP/etc/modprobe.d" '/etc'

    # X11
    cp -r "$DOTSYSP/etc/X11" '/etc'

    # sudo
    sed -i '/^# %sudo\tALL/ s/^# //' '/etc/sudoers'

    # time zone
    ln -sf '/usr/share/zoneinfo/Europe/Paris' '/etc/localtime'

    # localization
    sed -i '/^#en_US.UTF-8/ s/^#//' '/etc/locale.gen'
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo 'KEYMAP=fr' > /etc/vconsole.conf

    # network
    echo 'nanoha' > /etc/hostname

    # initramfs (requires: /etc/vconsole.conf)
    cp {"$DOTSYSP",}'/etc/mkinitcpio.conf'
    mkinitcpio --allpresets

    # bootloader
    cp {"$DOTSYSP",}'/etc/default/grub'
    grub-install --target='x86_64-efi' --efi-directory='/boot'
    grub-mkconfig -o '/boot/grub/grub.cfg'

    # users
    echo -n 'root '; passwd root
    groupadd sudo
    useradd luna --create-home --groups sudo
    echo -n 'luna '; passwd luna
}

setup.sys.systemd() {
    timedatectl set-ntp true
    timedatectl set-local-rtc false
    systemctl enable --now NetworkManager.service
    systemctl enable --now nftables.service
}

if [[ "$(type -t "setup.${1:-}")" == 'function' ]]; then
    "setup.$1" "${@:2}"
else
    setup.help
    exit 1
fi
