# dotfiles

Hyprland (0.55+, Lua config) rice for CachyOS · Catppuccin Mocha everywhere: Hyprland, waybar, swaync, rofi, alacritty, hyprlock, GTK.

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
config/hypr/        hyprland.lua, hypridle.conf, hyprlock.conf, wallpaper.jpg
config/hypr/scripts nightlight, osd, powermenu, wallpaper (display switching lives in hyprland.lua)
config/waybar/      config.jsonc, style.css, mocha.css, scripts/updates.sh
config/swaync/      notification + control center
config/rofi/        launcher theme
config/alacritty/   terminal theme
config/nvim/        Neovim, all Lua: init.lua → lua/config/{options,plugins,ui,keymaps,coc}.lua
                    (vim-plug; installer fetches plug.vim + runs :PlugInstall)
                    all nvim keys: config/nvim/README.md
config/starship.toml  zsh prompt (add `eval "$(starship init zsh)"` to ~/.zshrc)
config/gtk-3.0, gtk-4.0  Catppuccin colors over adw-gtk3-dark
install.sh
```

To add more (alacritty, rofi, gtk-3.0…), drop the folder into `config/` and rerun `install.sh`.
Because the configs are symlinked, edits in `~/.config` land in the repo. Commit and push them from `~/dotfiles`.

## Keys

Neovim keys are in [config/nvim/README.md](config/nvim/README.md). Hyprland:

| Key | Action |
|---|---|
| `Super+Return` | Terminal |
| `Super+D` | Launcher |
| `Super+V` | Clipboard history |
| `Super+Shift+N` | Control center (notifications, toggles, media, sliders) |
| `Super+N` | Toggle night light |
| `Super+Escape` / `Super+Shift+E` | Power menu |
| `Super+Shift+X` | Lock |
| `Super+Shift+Q` | Close window |
| `Super+F` / `Super+Shift+Space` | Fullscreen / float |
| `Super+R` | Resize mode (arrows, Esc to exit) |
| `Super+1..5` / `Super+Shift+1..5` | Go to / move to workspace |
| `Super+scroll` | Cycle workspaces |
| ``Super+` `` / ``Super+Shift+` `` | Scratchpad show / send |
| `Print` / `Super+Print` / `Super+Shift+S` | Full / region / flameshot screenshot |
| `Super+[ ]` / `Super+Shift+[ ]` | Inner / outer gaps |
| `Super+Shift+W` | Toggle waybar |
| `Super+Shift+C` | Reload |
| `Super+Shift+M` | Force laptop screen on (emergency) |

## Bar

Left: launcher (right-click = clipboard) · workspaces · media (scroll = next/prev)
Center: date (hover = calendar) · time capsule
Right: CPU (hover to reveal RAM / temp / disk) · volume + mic · brightness · network · bluetooth · battery · updates · caffeine · night light · tray · notifications · power

Wallpaper: drop `~/Pictures/wallpaper.jpg` to override the bundled one.
