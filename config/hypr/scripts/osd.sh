#!/usr/bin/env bash
# osd.sh vol-up|vol-down|mute|bright-up|bright-down — change level + show a swaync progress popup
notify() {  # $1 icon-name  $2 title  $3 value
    notify-send -a osd -u low -t 1200 -i "$1" \
        -h string:x-canonical-private-synchronous:osd \
        -h int:value:"$3" "$2" "$3%"
}

volume() {
    local out; out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    local v; v=$(awk '{printf "%d", $2*100}' <<<"$out")
    if [[ $out == *MUTED* ]]; then notify audio-volume-muted "Muted" "$v"
    else notify audio-volume-high "Volume" "$v"; fi
}

bright() {
    notify display-brightness "Brightness" "$(brightnessctl -m | cut -d, -f4 | tr -d %)"
}

case "$1" in
    vol-up)      wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+; volume ;;
    vol-down)    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-;        volume ;;
    mute)        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle;       volume ;;
    bright-up)   brightnessctl -q set 5%+; bright ;;
    bright-down) brightnessctl -q set 5%-; bright ;;
esac
