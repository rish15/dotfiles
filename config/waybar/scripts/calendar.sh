#!/usr/bin/env bash
# Calendar popup.
#   calendar.sh        toggle the calendar on today (click the date / Super+C)
#   calendar.sh jump   ask for a year or month+year, open the calendar there
#                      (right-click the date). Accepts: 2016 · 3 2016 · mar 2016 · 2016-03
# Stays open until Esc, or clicking the date / Super+C again.
close() { pkill -f 'yad --calendar --title=bar-calendar'; }
open_at() {   # $1 month (1-12), $2 year
    exec yad --calendar --title=bar-calendar --undecorated --no-buttons \
        --skip-taskbar --show-weeks --width=320 \
        ${2:+--year="$2"} ${1:+--month="$1"} ${1:+--day=1}
}

if [[ $1 == jump ]]; then
    close
    q=$(rofi -dmenu -p ' Go to' -mesg 'year, or month + year  (e.g. 2016 · mar 2016 · 3 2016)' \
        -theme-str 'window {width: 460px;} listview {lines: 0;}' </dev/null) || exit 0
    q=${q,,}; q=${q//[-\/,]/ }
    read -r a b <<<"$q"
    months=(jan feb mar apr may jun jul aug sep oct nov dec)
    mon_num() { local i; for i in "${!months[@]}"; do [[ $1 == ${months[$i]}* ]] && { echo $((i+1)); return; }; done
                [[ $1 =~ ^[0-9]{1,2}$ ]] && (( 10#$1 >= 1 && 10#$1 <= 12 )) && echo $((10#$1)); }
    if [[ $a =~ ^[0-9]{4}$ && -z $b ]]; then        open_at 1 "$a"          # 2016
    elif [[ $a =~ ^[0-9]{4}$ ]]; then              open_at "$(mon_num "$b")" "$a"   # 2016 03
    elif [[ $b =~ ^[0-9]{4}$ ]]; then              open_at "$(mon_num "$a")" "$b"   # mar 2016
    else notify-send -a calendar "Calendar" "Couldn't read \"$q\" — try 2016 or mar 2016"; fi
    exit 0
fi

close && exit 0
open_at
