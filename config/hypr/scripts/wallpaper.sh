#!/usr/bin/env bash
# Use ~/Pictures/wallpaper.{jpg,png} if present, else the bundled Catppuccin one
for w in ~/Pictures/wallpaper.jpg ~/Pictures/wallpaper.png ~/.config/hypr/wallpaper.jpg; do
    [[ -f $w ]] && exec swaybg -i "$w" -m fill
done
exec swaybg -c '#1e1e2e'
