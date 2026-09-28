#!/usr/bin/env bash
# ~/.config/hypr/scripts/display-watch.sh
# Replaces display-switch.sh + display-watch.sh from Sway.
# External (HDMI-A-1 or any DP) connected -> disable eDP-1; unplugged -> re-enable.

LAPTOP=eDP-1

switch() {
    if hyprctl monitors all -j | jq -e '.[] | select(.name != "'"$LAPTOP"'")' >/dev/null; then
        hyprctl eval "hl.monitor({ output = \"$LAPTOP\", disabled = true })" >/dev/null
    else
        hyprctl eval "hl.monitor({ output = \"$LAPTOP\", mode = \"preferred\", position = \"auto\", scale = \"1\" })" >/dev/null
    fi
}

switch
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
while read -r line; do
    case "$line" in
        monitoradded*|monitorremoved*) switch ;;
    esac
done
