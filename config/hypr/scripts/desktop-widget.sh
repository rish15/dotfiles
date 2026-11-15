#!/usr/bin/env bash
# (Re)start the desktop widget on the currently focused screen.
pkill -f 'desktop-widget\.py'
sleep 0.2
exec "$(dirname "$0")/desktop-widget.py" >/tmp/desktop-widget.log 2>&1
