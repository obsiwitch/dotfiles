#!/usr/bin/env python3

import subprocess

actions = {
    "1. reload"    : "i3-msg restart",
    "2. sleep"     : "xflock4 ; systemctl suspend",
    "3. hibernate" : "xflock4 ; systemctl hibernate",
    "4. logout"    : "i3-msg exit",
    "5. restart"   : "systemctl reboot",
    "6. shutdown"  : "systemctl poweroff",
}

choice = subprocess.run(
    text  = True,
    input = '\n'.join(actions.keys()),
    args  = [
        "dmenu",
        "-nb", "#282828", # normal background
        "-nf", "#F8F8F2", # normal foreground
        "-sb", "#D6D6D6", # selected background
        "-sf", "#282828", # selected foreground
    ],
    capture_output = True,
).stdout.rstrip("\n")

subprocess.run(
    args  = actions.get(choice, ""),
    shell = True,
)
