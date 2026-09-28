#!/usr/bin/env bash
# ~/.config/hypr/scripts/display-watch.sh
# Any external monitor connected -> disable the laptop panel; none -> re-enable it.
# Log: /tmp/display-watch.log

LAPTOP=eDP-1
LOG=/tmp/display-watch.log
exec >>"$LOG" 2>&1
echo "--- start $(date '+%F %T') sig=$HYPRLAND_INSTANCE_SIGNATURE"

externals() {
    hyprctl monitors all | awk '/^Monitor /{print $2}' | grep -vx "$LAPTOP"
}

switch() {
    local ext
    ext=$(externals)
    if [[ -n "$ext" ]]; then
        echo "$(date +%T) external: $(echo $ext) -> disable $LAPTOP"
        hyprctl eval "hl.monitor({ output = \"$LAPTOP\", disabled = true })"
    else
        echo "$(date +%T) no external -> enable $LAPTOP"
        hyprctl eval "hl.monitor({ output = \"$LAPTOP\", mode = \"preferred\", position = \"auto\", scale = \"1\" })"
    fi
}

# wait for Hyprland's event socket at login
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
for _ in $(seq 20); do [[ -S "$SOCK" ]] && break; sleep 0.5; done

switch
socat -U - "UNIX-CONNECT:$SOCK" |
while read -r line; do
    case "$line" in
        monitoradded\>\>*|monitorremoved\>\>*)
            [[ "$line" == *">>$LAPTOP" ]] && continue   # ignore our own enable/disable
            sleep 1
            switch
            ;;
    esac
done
echo "$(date +%T) socat exited"
