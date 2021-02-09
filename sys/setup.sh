#!/bin/bash

set -o errexit -o nounset -o xtrace

DOTFILESP="$(realpath "$(dirname "$0")/..")"
DOTSYSP="$DOTFILESP/sys"
PATH="$DOTFILESP/user/bin:$PATH"

setup.help() {
    echo 'Arch install script'
    echo
    echo 'references:'
    echo '* https://wiki.archlinux.org/index.php/installation_guide'
    echo '* https://wiki.archlinux.org/index.php/Dm-crypt'
    echo '* https://wiki.archlinux.org/index.php/Partitioning'
    echo
    echo "usage: $(basename "$0") <cmd>"
    echo 'live:     live.conf'
    echo 'live:     sys.init <device>'
    echo 'chroot:   sys.conf'
    echo 'system:   sys.systemd'
}

setup.live.conf() {
    # loadkeys fr
    # iwctl station $iface connect $ssid
    # pacman -Sy archlinux-keyring pacman-contrib git grub efibootmgr
    # git clone https://gitlab.com/Obsidienne/dotfiles.git
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
    pacstrap -i '/mnt' base base-devel linux-lts linux-firmware intel-ucode \
        amd-ucode grub efibootmgr archiso pacman-contrib networkmanager nftables \
        python python-pip

    # fstab
    genfstab -U '/mnt' > '/mnt/etc/fstab'

    # bootloader
    grub-install --target='x86_64-efi' \
        --efi-directory='/mnt/boot' \
        --boot-directory='/mnt/boot'

    # copy dotfiles
    cp -r "$DOTFILESP" '/mnt/root/'
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
    echo 'nanoha' > /etc/hostname

    # kernel modules
    cp -r "$DOTSYSP/etc/modprobe.d" '/etc'

    # initramfs (requires: /etc/vconsole.conf)
    cp {"$DOTSYSP",}'/etc/mkinitcpio.conf'
    mkinitcpio --allpresets

    # bootloader
    dottemplate "$DOTSYSP/etc/default/grub.tpl" \
        crypt_uuid="$(lsblk --nodeps --noheadings --output='UUID' '/dev/sda2')" \
        resume_offset="$(filefrag -v '/swapfile' | awk '/^ *0:/ {print $4}')" \
        | tee {"$DOTSYSP",}'/etc/default/grub' > /dev/null
    grub-mkconfig -o '/boot/grub/grub.cfg'

    # pacman
    cp {"$DOTSYSP",}'/etc/pacman.conf'

    # sudo
    sed -i '/^# %sudo\tALL/ s/^# //' '/etc/sudoers'
    groupadd -f sudo

    # users
    useradd luna --create-home --groups sudo || [[ "$?" -eq 9 ]]
    passwd --status luna | awk '$2 != "P" {exit 1}' || passwd luna
    passwd --status root | awk '$2 != "P" {exit 1}' || passwd root

    # X11
    cp -r "$DOTSYSP/etc/X11" '/etc'
}

setup.sys.systemd() {
    timedatectl set-ntp true
    timedatectl set-local-rtc false
    systemctl enable --now NetworkManager.service
    systemctl enable --now nftables.service
}

"setup.$1" "${@:2}" || {
    set +o xtrace
    setup.help
    exit 1
}
