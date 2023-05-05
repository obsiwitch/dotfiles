# Sdmap

https://user-images.githubusercontent.com/26996026/217802779-e0e85afe-37fc-4486-a3a4-bf1cb3db23c3.mp4

---

Sdmap remaps the Steam Deck controller and provides a gamepad mode and a desktop mode without the need to launch Steam. You need a kernel with support for the controller (linux 6.3 or [linux-neptune](https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter-main/os/x86_64/) or [hid-steam-deck-dkms](https://github.com/obsiwitch/dotfiles/tree/2ac2bb8d0bff49cac9b5d80f6b1d7e849707f293/packages/hid-steam-deck-dkms) or the following patches applied [p1](https://gitlab.com/evlaV/linux-integration/-/commit/72ce570d0b3ae23aaf74ae604d58a2c819d1b4a8) [p2](https://gitlab.com/evlaV/linux-integration/-/commit/4196619768de19274fcdba116eba81e36f9436bf) [p3](https://gitlab.com/evlaV/linux-integration/-/commit/c616088b5ac4fe34faadc314d71dc14c2e7ebc8c)).

~~~
SD controller -> Sdmap -> ungrab -> game
(input dev)            -> grab -> keyboard+trackpad (virtual dev) -> libinput -> wayland/xorg
~~~

## Install

A [PKGBUILD](arch/) is provided to [build and install](https://wiki.archlinux.org/title/Arch_User_Repository#Installing_and_upgrading_packages) Sdmap on Arch Linux. Once installed, the `sdmap.service` systemd service can be enabled and started (`systemctl enable --now sdmap.service`). The daemon can also be tested outside the service by running `sdmap-daemon`.

## Keybindings

* `BTN_THUMB`: switch between gamepad and desktop mode
* gamepad mode (ungrabbed input device)
* desktop mode (grabbed input device & output to virtual device)
    * pointer
        * `ABS_HAT1{X,Y}`: cursor
        * `BTN_TR`: left click
        * `BTN_TL`: right click
        * `BTN_TL2`: middle click
        * (libinput) middle click + cursor: scroll
    * keyboard
        * `ABS_HAT0{X,Y}` + `BTN_{SOUTH,EAST,NORTH,WEST,START,BASE,THUMBR}`: virtual keyboard
        * `BTN_DPAD_{UP,DOWN,LEFT,RIGHT}`: arrow keys
        * `ABS_{X,Y}`: home, end, pageup, pagedown
        * `BTN_SELECT`: tab
        * `BTN_START`: delete
        * `BTN_TRIGGER_HAPPY{1,3,4,2}`: shift, ctrl, alt, altgr
        * `BTN_TR2`: super
        * `BTN_SOUTH`: enter
        * `BTN_EAST`: esc
        * `BTN_NORTH`: backspace
        * `BTN_WEST`: space
        * `BTN_BASE`: compose
    * unused: `BTN_MODE`, `BTN_BASE` alone, `BTN_THUMBL`, `BTN_THUMBR` alone, `BTN_THUMB2`, `ABS_R{X,Y}`, `ABS_HAT2{X,Y}`

## Virtual Keyboard Sticker

![sticker](https://i.imgur.com/DHEOmFD.png)

A [sticker](https://i.imgur.com/DHEOmFD.png) can be generated and [printed](https://i.imgur.com/a7Mk0GY.jpg) for the virtual keyboard on the left trackpad. It's a simple solution that didn't require me to develop a GUI. I printed the sticker on photo paper, pierced holes from the back of the paper to create bumps for tactile feedback, and glued it.

~~~sh
sdmap-sticker > sticker.html
chromium --headless --screenshot=sticker.png sticker.html
convert -trim -density 300 sticker.png{,} # 378px / 300ppi = 1.26in ≈ 3.2cm
~~~
