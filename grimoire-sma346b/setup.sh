#!/bin/bash

set -o errexit -o nounset

setup_settings() {
    declare -A settings=(
        ['global:adb_enabled']=1
        ['global:device_name']='grimoire-sma346b'
        ['global:animator_duration_scale']=0.0
        ['global:transition_animation_scale']=0.0
        ['global:window_animation_scale']=0.0

        ['secure:autofill_service']='org.mozilla.firefox/org.mozilla.fenix.autofill.AutofillService'
        ['secure:bluetooth_name']='grimoire-sma346b'
        ['secure:display_density_forced']=420
        ['secure:location_mode']=0
        ['secure:lock_screen_allow_private_notifications']=0
        ['secure:lock_screen_lock_after_timeout']=5000
        ['secure:lock_screen_show_notifications']=1
        ['secure:navigation_mode']=0
        ['secure:refresh_rate_mode']=0
        ['secure:screensaver_enabled']=0
        ['secure:sysui_qs_tiles']='Wifi,MobileData,Bluetooth,Location,AirplaneMode,SoundMode,RotationLock,Flashlight'
        ['secure:charging_sounds_enabled']=0
        ['secure:charging_vibration_enabled']=0
        ['secure:emergency_gesture_enabled']=0
        ['secure:silence_gesture']=0
        ['secure:skip_gesture']=0
        ['secure:wake_gesture_enabled']=0

        ['system:accelerometer_rotation']=0
        ['system:font_scale']=1.0
        ['system:haptic_feedback_enabled']=0
        ['system:lockscreen_sounds_enabled']=0
        ['system:notification_light_pulse']=0
        ['system:screen_brightness_mode']=0
        ['system:screen_off_timeout']=300000
        ['system:sound_effects_enabled']=0
        ['system:system_locales']='en-GB,fr-FR'
        ['system:vibrate_when_ringing']=1
        ['system:volume_music_speaker']=0
        ['system:volume_notification_speaker']=0
        ['system:volume_ring_speaker']=0
        ['system:volume_system_speaker']=0
        ['system:super_fast_charging']=0
    )
    for nk in "${!settings[@]}"; do
        read -r namespace key <<< "${nk//:/ }"
        adb shell settings put "$namespace" "$key" "${settings[$nk]}"
    done
}

setup_settings
echo 'packages debloating: see https://github.com/0x192/universal-android-debloater/tree/main'
