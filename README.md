# dotfiles

Hyprland (0.55+, Lua config) setup for CachyOS, ported from my Sway config.

## Install

Fresh machine:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rish15/dotfiles/main/install.sh)
```

Already cloned:

```bash
~/dotfiles/install.sh            # packages + links
~/dotfiles/install.sh --no-pkgs  # links only
~/dotfiles/install.sh --dry-run  # show what would happen
```

The installer symlinks every folder in `config/` into `~/.config/`. Existing configs get moved to `~/.dotfiles-backup/<timestamp>/`. It's safe to run again.

## Layout

```
config/hypr/      hyprland.lua, hypridle.conf, hyprlock.conf, scripts/display-watch.sh
config/waybar/    config.jsonc, style.css
install.sh
```

To add more (alacritty, rofi, gtk-3.0…), drop the folder into `config/` and rerun `install.sh`.
Because the configs are symlinked, edits in `~/.config` land in the repo. Commit and push them from `~/dotfiles`.

## Keys

| Key | Action |
|---|---|
| `Super+Return` | Terminal |
| `Super+D` | Launcher |
| `Super+V` | Clipboard history |
| `Super+Shift+X` | Lock |
| `Super+Shift+Q` | Close window |
| `Super+F` / `Super+Shift+Space` | Fullscreen / float |
| `Super+R` | Resize mode (arrows, Esc to exit) |
| `Super+1..5` / `Super+Shift+1..5` | Go to / move to workspace |
| `Print` / `Super+Print` / `Super+Shift+S` | Full / region / flameshot screenshot |
| `Super+[ ]` / `Super+Shift+[ ]` | Inner / outer gaps |
| `Super+N` | Toggle night light |
| `Super+Shift+C` | Reload |
