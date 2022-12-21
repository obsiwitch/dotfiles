# Sdmap

Sdmap remaps the Steam Deck controller and provides a gamepad mode and a desktop mode without the need to launch Steam. You need a kernel with support for the controller ([linux-neptune](https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter-main/os/x86_64/), or [hid-steam-deck-dkms](https://github.com/obsiwitch/dotfiles/tree/main/packages/hid-steam-deck-dkms), or the following patches applied [p1](https://gitlab.com/evlaV/linux-integration/-/commit/72ce570d0b3ae23aaf74ae604d58a2c819d1b4a8) [p2](https://gitlab.com/evlaV/linux-integration/-/commit/4196619768de19274fcdba116eba81e36f9436bf) [p3](https://gitlab.com/evlaV/linux-integration/-/commit/c616088b5ac4fe34faadc314d71dc14c2e7ebc8c)).

~~~
SD controller -> Sdmap -> ungrab -> gamepad (input dev) -> game
(input dev)            -> grab -> keyboard+trackpad (virtual dev) -> libinput -> wayland/xorg
~~~

## Install

A [PKGBUILD](arch/PKGBUILD) is provided to [build and install](https://wiki.archlinux.org/title/Arch_User_Repository#Installing_and_upgrading_packages) Sdmap on Arch Linux. Once installed, the `sdmap.service` systemd service can be enabled and started (`systemctl enable --now sdmap.service`). The daemon can also be tested outside the service by running (`sdmap-daemon`) (requires the service to be stopped).

## Keybindings

* STEAM + …: switch between gamepad and desktop mode
* gamepad mode (ungrabbed input device)
* desktop mode (grabbed input device & output to virtual device)
    * trackpad
        * right trackpad: cursor
        * left bumper: right click
        * right bumper: left click
        * left trigger: middle click
        * (libinput) middle click + cursor: scroll
    * keyboard
        * left trackpad + {A,B,X,Y,start,…}: virtual keyboard
        * DPAD: arrow keys
        * left stick: home, end, pageup, pagedown
        * right stick: F1, F2, F3, F4
        * select: tab
        * start: delete
        * back buttons: shift, ctrl, alt, altgr
        * right trigger: super
        * A: enter
        * B: esc
        * X: backspace
        * Y: space
        * …: compose
    * unused: BTN_MODE, BTN_THUMBL, BTN_THUMBR, BTN_THUMB, BTN_THUMB2

## Virtual Keyboard Sticker

![sticker](https://i.imgur.com/DHEOmFD.png)

A [sticker](https://i.imgur.com/DHEOmFD.png) can be generated and [printed](https://i.imgur.com/a7Mk0GY.jpg) for the virtual keyboard on the left trackpad. It's a simple solution that didn't require me to develop a GUI. I printed the sticker on photo paper, pierced holes from the back of the paper to create bumps for tactile feedback, and glued it.

~~~sh
sdmap-sticker > sticker.html
chromium --headless --screenshot=sticker.png sticker.html
convert -trim -density 300 sticker.png{,} # 378px / 300ppi = 1.26in ≈ 3.2cm
~~~
