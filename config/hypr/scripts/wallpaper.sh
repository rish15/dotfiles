#!/usr/bin/env bash
# Use ~/Pictures/wallpaper.{jpg,png} if present, else the bundled Catppuccin one.
# Also points ~/.cache/lockscreen.jpg at a JPG wallpaper for hyprlock's background
# (a static image is far more reliable than hyprlock's live screenshot).
mkdir -p ~/.cache
lock_bg=~/.config/hypr/wallpaper.jpg
[[ -f ~/Pictures/wallpaper.jpg ]] && lock_bg=~/Pictures/wallpaper.jpg
ln -sf "$lock_bg" ~/.cache/lockscreen.jpg

for w in ~/Pictures/wallpaper.jpg ~/Pictures/wallpaper.png ~/.config/hypr/wallpaper.jpg; do
    [[ -f $w ]] && exec swaybg -i "$w" -m fill
done
exec swaybg -c '#1e1e2e'
