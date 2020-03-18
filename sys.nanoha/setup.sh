#!/bin/bash

set -o errexit -o nounset

DOTFILESP="$(realpath "$(dirname "$0")/../..")"
DOTNANOHAP="$DOTFILESP/sys.nanoha"
PATH="$DOTFILESP/user/bin:$PATH"

source dotfail

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
    echo '  packages.{core,cli,gui} <root>'
    echo '  bootloader [device]'
    echo '  provision'
    echo '  configure'
}

setup.packages.core() {
    [[ -d "${1:-}" ]] || dotfail 'specify root directory'
    local pac="pacstrap -i $1"
    $pac base base-devel linux-lts linux-firmware intel-ucode grub \
        pacman-contrib arch-install-scripts networkmanager nftables
}

setup.packages.cli() {
    [[ -d "${1:-}" ]] || dotfail 'specify root directory'
    local pac="pacstrap -i $1"
    $pac man bash-completion shellcheck less moreutils nano neovim git python \
        python-pip fzf pdfgrep jq yq wget curl links openssh nmap whois \
        speedtest-cli youtube-dl rsync ranger trash-cli atool p7zip unrar unzip \
        zip htop iotop lshw ncdu tree nethogs android-tools gocryptfs \
        imagemagick inotify-tools dosfstools tcc gdb valgrind testdisk
}

setup.packages.gui() {
    [[ -d "${1:-}" ]] || dotfail 'specify root directory'
    local pac="pacstrap -i $1"
    $pac xorg xorg-xinit arandr xclip pulseaudio pamixer pavucontrol pasystray \
        xfce4-power-manager network-manager-applet gnome-themes-extra redshift \
        papirus-icon-theme kitty thunar tumbler ffmpegthumbnailer nemo \
        dconf-editor gvfs gvfs-mtp meld firefox transmission-gtk soundconverter \
        quodlibet gimp tiled inkscape eom mpv blender openscad evince mupdf \
        texlive-most texlive-langextra pandoc libreoffice hunspell-fr \
        hunspell-en_US adobe-source-han-sans-jp-fonts otf-font-awesome pluma \
        atom galculator keepassxc gparted xfce4-screenshooter \
        simplescreenrecorder ghex i3 dmenu rofi dunst feh \
        cups hplip system-config-printer sane simplescan
}

setup.bootloader() {
    if [[ -d /sys/firmware/efi ]]; then
        grub-install --target='x86_64-efi' --efi-directory='/boot/efi'
    else
        [[ -b "${1:-}" ]] || dotfail 'specify a block device'
        grub-install --target='i386-pc' "$1"
    fi
    grub-mkconfig -o /boot/grub/grub.cfg
}

setup.provision() {
    # kernel modules
    dotcp "$DOTNANOHAP/kernel/blacklist.conf" '/etc/modprobe.d/'

    # X11
    dotcp "$DOTNANOHAP/xorg/"* '/etc/X11/xorg.conf.d/'

    # firewall
    dotcp "$DOTNANOHAP/security/nftables.conf" '/etc/'

    # sudo
    dotcp "$DOTNANOHAP/security/sudo_group" '/etc/sudoers.d/group'
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
    localectl set-locale LANG=en_US.UTF-8
    localectl set-keymap fr

    # network
    hostnamectl set-hostname nanoha

    # users
    echo 'root' && passwd root
    groupadd sudo || :
    useradd luna --create-home --groups sudo || :
    echo 'luna' && passwd luna

    # services
    systemctl enable NetworkManager.service
    systemctl enable nftables.service
}

if [[ "$(type -t "setup.${1:-}")" == 'function' ]]; then
    "setup.$1" "${@:2}"
else
    setup.help
    exit 1
fi
