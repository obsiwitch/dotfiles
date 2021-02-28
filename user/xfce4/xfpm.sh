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
xfconf-set 'general-notification' 'bool' 'false'
xfconf-set 'show-tray-icon' 'bool' 'true'

# System
xfconf-set 'logind-handle-lid-switch' 'bool' 'false'
xfconf-set 'lid-action-on-battery' 'uint' '2'
xfconf-set 'lid-action-on-ac' 'uint' '2'

xfconf-set 'critical-power-action' 'uint' '2'

xfconf-set 'lock-screen-suspend-hibernate' 'bool' 'false'

# Display
xfconf-set 'dpms-enabled' 'bool' 'false'
xfconf-set 'blank-on-battery' 'int' '0' # xset s 0
xfconf-set 'blank-on-ac' 'int' '0' # xset s 0

xfconf-set 'brightness-on-battery' 'uint' '9'
xfconf-set 'brightness-on-ac' 'uint' '9'
