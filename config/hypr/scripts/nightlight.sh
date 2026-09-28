#!/usr/bin/env bash
# nightlight.sh toggle|status — gammastep on/off, synced with waybar (signal 8)
MOON=$''

case "$1" in
    toggle)
        if pgrep -x gammastep >/dev/null; then
            pkill -x gammastep
        else
            gammastep -l geoclue2 >/dev/null 2>&1 &
            disown
        fi
        sleep 0.2
        pkill -RTMIN+8 waybar
        ;;
    status|*)
        if pgrep -x gammastep >/dev/null; then
            printf '{"text":"%s","class":"on","tooltip":"Night light on"}\n' "$MOON"
        else
            printf '{"text":"%s","class":"off","tooltip":"Night light off"}\n' "$MOON"
        fi
        ;;
esac
