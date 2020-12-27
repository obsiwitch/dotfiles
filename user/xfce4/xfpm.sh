#!/bin/bash

set -o errexit -o nounset

channel='xfce4-power-manager'
xfconf-query() {
    /usr/bin/xfconf-query --channel="$channel" "$@"
}
xfconf-set() {
    xfconf-query --create --property="/$channel/$1" --type="$2" --set="$3"
}

xfconf-query --reset --recursive --property="/$channel"

# General
xfconf-set 'show-tray-icon' 'bool' 'true'

# System
xfconf-set 'logind-handle-lid-switch' 'bool' 'false'
xfconf-set 'lid-action-on-battery' 'uint' '2'
xfconf-set 'lid-action-on-ac' 'uint' '2'

xfconf-set 'critical-power-action' 'uint' '2'

# Display
xfconf-set 'blank-on-battery' 'int' '0' # xset s 0
xfconf-set 'dpms-on-battery-sleep' 'uint' '0' # xset dpms 0 _ _
xfconf-set 'dpms-on-battery-off' 'uint' '5' # xset dpms _ _ 300

xfconf-set 'blank-on-ac' 'int' '0' # xset s 0
xfconf-set 'dpms-on-ac-sleep' 'uint' '0' # xset dpms 0 _ _
xfconf-set 'dpms-on-ac-off' 'uint' '5' # xset dpms _ _ 300

xfconf-set 'brightness-on-battery' 'uint' '9'
xfconf-set 'brightness-on-ac' 'uint' '9'
