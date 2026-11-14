#!/usr/bin/env bash
# Toggle a small calendar popup (click the date on the bar, or Super+C).
# Closes when you click elsewhere.
if pkill -f 'yad --calendar --title=bar-calendar'; then exit 0; fi
exec yad --calendar --title=bar-calendar --undecorated --close-on-unfocus \
    --no-buttons --skip-taskbar --show-weeks --width=320
