#!/bin/bash

set -o errexit -o nounset

sourcep="$(realpath "${BASH_SOURCE%/*}")"

fdroid_install() {
    if [[ "$(adb shell pm list packages "$1")" ]]; then return; fi
    local version; version="$(curl -s "https://f-droid.org/api/v1/packages/$1" \
                              | jq '.suggestedVersionCode')"
    local apk="$1_$version.apk"
    local url="https://f-droid.org/repo/$apk"
    wget --no-clobber "$url"
    adb install "$apk"
    rm "$apk"
}

setup_packages() {
    while read -r pkg; do
        fdroid_install "$pkg"
    done < "$sourcep/pkg_fdroid"

    diff --color=always --unified=0 \
        <(sort "$sourcep"/pkg_* | sed 's/^/package\:/') \
        <(adb shell pm list packages -3 | sort) || :
}

setup_settings() {
    declare -A settings=(
        ['global:device_name']='grimoire-n22'
        ['global:google_assistant_button_on']=0
        ['global:bluetooth_on']=0
        ['global:wifi_networks_available_notification_on']=0
        ['global:animator_duration_scale']=0
        ['global:transition_animation_scale']=0
        ['global:window_animation_scale']=0

        ['secure:autofill_service']='org.mozilla.firefox/org.mozilla.fenix.autofill.AutofillService'
        ['secure:bluetooth_name']='grimoire-n22'
        ['secure:display_density_forced']=272
        ['secure:location_mode']=0
        ['secure:lock_screen_allow_private_notifications']=0
        ['secure:navigation_mode']=0
        ['secure:night_display_activated']=1
        ['secure:night_display_color_temperature']=4082
        ['secure:screensaver_enabled']=0
        ['secure:sysui_qs_tiles']='wifi,cell,bt,location,dnd,airplane,flashlight,rotation,hotspot'

        ['system:accelerometer_rotation']=0
        ['system:font_scale']=1.3
        ['system:haptic_feedback_enabled']=0
        ['system:lockscreen_sounds_enabled']=0
        ['system:notification_light_pulse']=0
        ['system:screen_brightness_mode']=0
        ['system:screen_off_timeout']=300000
        ['system:sound_effects_enabled']=0
        ['system:status_bar_show_battery_percent']=1
        ['system:system_locales']='en-GB,fr-FR'
        ['system:vibrate_when_ringing']=1
        ['system:dtmf_tone']=0
        ['system:volume_music_speaker']=0
    )
    for nk in "${!settings[@]}"; do
        read -r namespace key <<< "${nk//:/ }"
        adb shell settings put "$namespace" "$key" "${settings[$nk]}"
    done
}

setup_packages
setup_settings
