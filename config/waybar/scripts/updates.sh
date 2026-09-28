#!/usr/bin/env bash
# Waybar: pending package updates (repo + AUR if paru is installed)
repo=$(checkupdates 2>/dev/null | wc -l)
aur=0
command -v paru >/dev/null && aur=$(paru -Qua 2>/dev/null | wc -l)
total=$((repo + aur))

if (( total == 0 )); then
    printf '{"text":"0","class":"none","tooltip":"System up to date"}\n'
else
    printf '{"text":"%s","class":"pending","tooltip":"%s repo · %s AUR\\nclick to update"}\n' "$total" "$repo" "$aur"
fi
