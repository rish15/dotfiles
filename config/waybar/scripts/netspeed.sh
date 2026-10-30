#!/usr/bin/env bash
# Waybar: live download / upload speed in kbps, e.g. "120kbps / 100kbps".
# Long-running: prints one JSON line every INTERVAL seconds.
INTERVAL=2
ICON=$''

iface() {   # interface carrying the default route (wifi or ethernet), from the kernel table
    awk '$2=="00000000" {print $1; exit}' /proc/net/route
}

bytes() {   # rx tx for $1
    awk -v d="$1:" '$1==d {print $2, $10}' /proc/net/dev
}

prev_if="" ; prx=0 ; ptx=0
while true; do
    i=$(iface)
    if [[ -z $i ]]; then
        printf '{"text":"%s offline","class":"offline","tooltip":"No network"}\n' "$ICON"
        prev_if=""; sleep "$INTERVAL"; continue
    fi
    read -r rx tx < <(bytes "$i")
    if [[ $i == "$prev_if" && -n $rx ]]; then
        down=$(( (rx - prx) * 8 / 1000 / INTERVAL ))
        up=$((   (tx - ptx) * 8 / 1000 / INTERVAL ))
        (( down < 0 )) && down=0; (( up < 0 )) && up=0
        printf '{"text":"%s %skbps / %skbps","class":"active","tooltip":"%s\\n↓ download %s kbps\\n↑ upload %s kbps"}\n' \
            "$ICON" "$down" "$up" "$i" "$down" "$up"
    fi
    prev_if=$i; prx=${rx:-0}; ptx=${tx:-0}
    sleep "$INTERVAL"
done
