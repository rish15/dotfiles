#!/usr/bin/env bash
# Super+P display menu. Saves the choice and reloads; hyprland.lua applies it.
# The laptop panel is never disabled — only powered off — so a screen always exists.
MODE_FILE="$HOME/.cache/hypr-display-mode"
mkdir -p "$(dirname "$MODE_FILE")"
set_mode() { printf '%s' "$1" > "$MODE_FILE"; hyprctl reload >/dev/null; }

externals=$(hyprctl monitors all -j | jq -r '.[].name' |
    grep -vx -e eDP-1 -e FALLBACK | grep -vc '^HEADLESS')

if (( externals == 0 )); then
    set_mode external   # default; with nothing plugged in it simply uses the laptop
    notify-send -a display -i video-display "Display" "No external screen — using laptop"
    exit 0
fi

EXTERNAL_ONLY=$'  External only (default)'
LAPTOP_ONLY=$'  Laptop only'
BOTH=$'  Both (extend)'
MIRROR=$'  Mirror'

choice=$(printf '%s\n' "$EXTERNAL_ONLY" "$LAPTOP_ONLY" "$BOTH" "$MIRROR" |
    rofi -dmenu -i -p "Display" -theme-str 'window {width: 380px;} listview {lines: 4;}')

case "$choice" in
    "$EXTERNAL_ONLY") set_mode external ;;
    "$LAPTOP_ONLY")   set_mode laptop ;;
    "$BOTH")          set_mode both ;;
    "$MIRROR")        set_mode mirror ;;
    *) exit 0 ;;
esac
notify-send -a display -i video-display "Display" "${choice#*  }"
