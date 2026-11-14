#!/usr/bin/env bash
# Toggle a small calendar popup (click the date on the bar, or Super+C).
# Stays open until you press Esc, click the date again or press Super+C again
# (focus follows the mouse, so "close when unfocused" closed it on any mouse move).
if pkill -f 'yad --calendar --title=bar-calendar'; then exit 0; fi
exec yad --calendar --title=bar-calendar --undecorated \
    --no-buttons --skip-taskbar --show-weeks --width=320
