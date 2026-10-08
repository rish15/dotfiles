#!/usr/bin/env bash
# Super+P display menu (like Ubuntu): laptop only / external only / both / mirror
LAPTOP=eDP-1

mapfile -t EXTERNALS < <(hyprctl monitors all -j | jq -r '.[].name' |
    grep -vx -e "$LAPTOP" -e FALLBACK | grep -v '^HEADLESS')

on()  { hyprctl eval "hl.monitor({ output = \"$1\", mode = \"preferred\", position = \"$2\", scale = \"1\" })" >/dev/null; }
off() { hyprctl eval "hl.monitor({ output = \"$1\", disabled = true })" >/dev/null; }
mirror() { hyprctl eval "hl.monitor({ output = \"$1\", mode = \"preferred\", position = \"auto\", scale = \"1\", mirror = \"$LAPTOP\" })" >/dev/null; }

if (( ${#EXTERNALS[@]} == 0 )); then
    on "$LAPTOP" "0x0"
    notify-send -a display -i video-display "Display" "No external screen connected — using laptop"
    exit 0
fi

LAPTOP_ONLY=$'  Laptop only'
EXTERNAL_ONLY=$'  External only'
BOTH=$'  Both (extend)'
MIRROR=$'  Mirror'

choice=$(printf '%s\n' "$LAPTOP_ONLY" "$EXTERNAL_ONLY" "$BOTH" "$MIRROR" |
    rofi -dmenu -i -p "Display" -theme-str 'window {width: 360px;} listview {lines: 4;}')

case "$choice" in
    "$LAPTOP_ONLY")
        on "$LAPTOP" "0x0"
        for e in "${EXTERNALS[@]}"; do off "$e"; done ;;
    "$EXTERNAL_ONLY")
        for e in "${EXTERNALS[@]}"; do on "$e" "auto"; done
        sleep 0.5; off "$LAPTOP" ;;
    "$BOTH")
        on "$LAPTOP" "0x0"
        for e in "${EXTERNALS[@]}"; do on "$e" "auto-right"; done ;;
    "$MIRROR")
        on "$LAPTOP" "0x0"
        for e in "${EXTERNALS[@]}"; do mirror "$e"; done ;;
    *) exit 0 ;;
esac

notify-send -a display -i video-display "Display" "${choice#*  }"
