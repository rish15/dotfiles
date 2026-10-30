#!/usr/bin/env bash
# Waybar: live download / upload speed, e.g. "120kbps / 100kbps" or "12.4Mbps / 850kbps".
# Long-running: prints one JSON line every INTERVAL seconds.
INTERVAL=2
ICON=$''

iface() {   # interface carrying the default route (wifi or ethernet), from the kernel table
    awk '$2=="00000000" {print $1; exit}' /proc/net/route
}

fmt() {     # kbps -> "850kbps" / "12.4Mbps" / "1.2Gbps"
    awk -v k="$1" 'BEGIN {
        if (k >= 1000000)   printf "%.1fGbps", k / 1000000
        else if (k >= 1000) printf "%.1fMbps", k / 1000
        else                printf "%dkbps",   k
    }'
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
        d=$(fmt "$down"); u=$(fmt "$up")
        printf '{"text":"%s %s / %s","class":"active","tooltip":"%s\\n↓ download %s\\n↑ upload %s"}\n' \
            "$ICON" "$d" "$u" "$i" "$d" "$u"
    fi
    prev_if=$i; prx=${rx:-0}; ptx=${tx:-0}
    sleep "$INTERVAL"
done
