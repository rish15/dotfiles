#!/usr/bin/env bash
# Rofi power menu
lock=$'  Lock'
suspend=$'  Suspend'
logout=$'  Log out'
reboot=$'  Reboot'
shutdown=$'  Shut down'

choice=$(printf '%s\n' "$lock" "$suspend" "$logout" "$reboot" "$shutdown" |
    rofi -dmenu -i -p "$(uptime -p | sed 's/up //')" -theme-str 'window {width: 360px;} listview {lines: 5;}')

case "$choice" in
    "$lock")     hyprlock ;;
    "$suspend")  loginctl lock-session; systemctl suspend ;;
    "$logout")   hyprctl dispatch 'hl.dsp.exit()' ;;
    "$reboot")   systemctl reboot ;;
    "$shutdown") systemctl poweroff ;;
esac
