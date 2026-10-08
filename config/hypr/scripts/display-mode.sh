#!/usr/bin/env bash
# Super+P display menu (like Ubuntu): laptop only / external only / both / mirror.
# Saves the choice and reloads Hyprland; hyprland.lua applies it on load.
LAPTOP=eDP-1
MODE_FILE="$HOME/.cache/hypr-display-mode"
mkdir -p "$(dirname "$MODE_FILE")"

set_mode() { printf '%s' "$1" > "$MODE_FILE"; hyprctl reload >/dev/null; }

externals=$(hyprctl monitors all -j | jq -r '.[].name' |
    grep -vx -e "$LAPTOP" -e FALLBACK | grep -vc '^HEADLESS')

if (( externals == 0 )); then
    set_mode both
    notify-send -a display -i video-display "Display" "No external screen — using laptop"
    exit 0
fi

LAPTOP_ONLY=$'  Laptop only'
EXTERNAL_ONLY=$'  External only'
BOTH=$'  Both (extend)'
MIRROR=$'  Mirror'

choice=$(printf '%s\n' "$BOTH" "$LAPTOP_ONLY" "$EXTERNAL_ONLY" "$MIRROR" |
    rofi -dmenu -i -p "Display" -theme-str 'window {width: 360px;} listview {lines: 4;}')

case "$choice" in
    "$LAPTOP_ONLY")   set_mode laptop ;;
    "$EXTERNAL_ONLY") set_mode external ;;
    "$BOTH")          set_mode both ;;
    "$MIRROR")        set_mode mirror ;;
    *) exit 0 ;;
esac

notify-send -a display -i video-display "Display" "${choice#*  }"
