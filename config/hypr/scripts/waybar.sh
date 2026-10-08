#!/usr/bin/env bash
# Run waybar and bring it back if it crashes (e.g. on monitor hotplug).
# A deliberate stop (pkill / Super+Shift+W) exits cleanly and is NOT restarted.
pgrep -x waybar >/dev/null && exit 0
while true; do
    waybar
    code=$?
    # 0 = normal exit, 143 = SIGTERM from pkill -> user wants it gone
    [[ $code -eq 0 || $code -eq 143 ]] && break
    echo "$(date '+%F %T') waybar exited ($code), restarting" >> /tmp/waybar-restarts.log
    sleep 1
done
