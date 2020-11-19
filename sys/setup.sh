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
    echo '  provision'
    echo '  configure'
    echo '  bootloader [device]'
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
