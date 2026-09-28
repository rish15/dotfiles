#!/usr/bin/env bash
# Rishu's Hyprland dotfiles installer (CachyOS / Arch)
#
# Fresh machine:
#   bash <(curl -fsSL https://raw.githubusercontent.com/rish15/dotfiles/main/install.sh)
# Already cloned:
#   ~/dotfiles/install.sh [--no-pkgs] [--dry-run]
#
# Safe to re-run: existing configs are backed up once, then symlinked.

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/rish15/dotfiles.git}"
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

INSTALL_PKGS=1
DRY=0
for arg in "$@"; do
    case "$arg" in
        --no-pkgs) INSTALL_PKGS=0 ;;
        --dry-run) DRY=1 ;;
        -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
        *) echo "unknown flag: $arg"; exit 1 ;;
    esac
done

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
run()  { if [[ $DRY == 1 ]]; then echo "  [dry] $*"; else "$@"; fi; }

PKGS=(
    # compositor + session
    hyprland hypridle hyprlock xdg-desktop-portal-hyprland polkit-kde-agent
    # bar / launcher / notifications / terminal
    waybar rofi-wayland swaync alacritty
    # wallpaper, clipboard, screenshots
    swaybg cliphist wl-clipboard grim slurp flameshot
    # night light, brightness, audio, media, network, bluetooth
    gammastep brightnessctl pipewire wireplumber pavucontrol playerctl
    network-manager-applet bluez bluez-utils blueman
    # bar helpers
    jq socat libnotify pacman-contrib btop git
    # theme: GTK, icons, Qt, fonts
    adw-gtk-theme papirus-icon-theme qt6ct ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
)

# 1. Clone (or update) the repo when run via curl
if [[ ! -d "$DOTFILES/.git" ]]; then
    command -v git >/dev/null || run sudo pacman -S --needed --noconfirm git
    log "Cloning $REPO_URL -> $DOTFILES"
    run git clone "$REPO_URL" "$DOTFILES"
else
    log "Updating $DOTFILES"
    run git -C "$DOTFILES" pull -q --ff-only 2>/dev/null || warn "git pull failed, using local copy"
fi

# 2. Packages
if [[ $INSTALL_PKGS == 1 ]]; then
    command -v pacman >/dev/null || { warn "pacman not found — use --no-pkgs on non-Arch"; exit 1; }
    log "Installing packages"
    run sudo pacman -Syu --needed --noconfirm "${PKGS[@]}"
fi

# 3. Symlink every dir in config/ into ~/.config
log "Linking configs"
mkdir -p "$HOME/.config"
for src in "$DOTFILES"/config/*; do
    name=$(basename "$src")
    dest="$HOME/.config/$name"

    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        echo "  ok      $name"
        continue
    fi
    if [[ -e "$dest" || -L "$dest" ]]; then
        run mkdir -p "$BACKUP"
        run mv "$dest" "$BACKUP/"
        echo "  backup  $name -> $BACKUP/"
    fi
    run ln -s "$src" "$dest"
    echo "  linked  $name"
done

# 4. Scripts executable, folders the config expects
run chmod +x "$DOTFILES"/config/hypr/scripts/*.sh "$DOTFILES"/config/waybar/scripts/*.sh
run mkdir -p "$HOME/Pictures"

# 5. Theme: GTK apps + icons (Catppuccin colors come from gtk-3.0/gtk-4.0 gtk.css)
if command -v gsettings >/dev/null; then
    log "Applying GTK theme"
    run gsettings set org.gnome.desktop.interface gtk-theme    'adw-gtk3-dark'
    run gsettings set org.gnome.desktop.interface icon-theme   'Papirus-Dark'
    run gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    run gsettings set org.gnome.desktop.interface font-name    'Noto Sans 10'
    run gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11'
fi

# Noctalia (CachyOS's default shell) draws its own bar + wallpaper on top of ours
if pgrep -f noctalia >/dev/null; then
    warn "Noctalia shell is running — it will overlap waybar. Disable its autostart, e.g.:"
    warn "  grep -ril noctalia ~/.config/autostart /etc/xdg/autostart ~/.config/systemd/user 2>/dev/null"
fi

# 6. Services
run systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
run sudo systemctl enable --now bluetooth 2>/dev/null || true

# 7. Reload if we're already inside Hyprland
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    log "Reloading Hyprland, waybar, swaync"
    run hyprctl reload >/dev/null
    run pkill waybar || true
    run pkill swaync || true
    [[ $DRY == 1 ]] || { (waybar >/dev/null 2>&1 & disown); (swaync >/dev/null 2>&1 & disown); }
fi

log "Done. Log out and pick Hyprland at the login screen if you're not in it yet."
