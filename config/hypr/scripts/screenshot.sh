#!/usr/bin/env bash
# screenshot.sh full|region — full = the focused screen only
f=~/Pictures/screenshot-$(date +%F-%H%M%S).png
mkdir -p ~/Pictures
case "$1" in
    region)
        grim -g "$(slurp)" "$f" && wl-copy < "$f" && notify-send -i "$f" "Region copied" "$f" ;;
    *)
        out=$(hyprctl monitors -j | jq -r '.[] | select(.focused).name')
        grim -o "$out" "$f" && notify-send -i "$f" "Screenshot saved" "$f" ;;
esac
