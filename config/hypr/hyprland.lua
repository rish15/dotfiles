-- ~/.config/hypr/hyprland.lua — Rishu's rice · Catppuccin Mocha (Hyprland 0.55+ Lua config)

----------------------
---- PALETTE ---------
----------------------
local c = {
    base = "1e1e2e", mantle = "181825", crust = "11111b",
    surface0 = "313244", surface1 = "45475a", overlay0 = "6c7086",
    text = "cdd6f4", mauve = "cba6f7", blue = "89b4fa", lavender = "b4befe",
    teal = "94e2d5", red = "f38ba8",
}
local function rgba(hex, a) return "rgba(" .. hex .. (a or "ff") .. ")" end

----------------------
---- VARIABLES -------
----------------------
local mod     = "SUPER"
local term    = "alacritty"
local menu    = "rofi -show drun"
local scripts = "~/.config/hypr/scripts/"

local function k(keys) return mod .. " + " .. keys end
local exec = hl.dsp.exec_cmd

----------------------
---- MONITORS --------
----------------------
-- eDP-1 gets disabled automatically by scripts/display-watch.sh when an external screen is plugged in
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = "1" })
hl.monitor({ output = "",      mode = "preferred", position = "auto", scale = "1" })

----------------------
---- AUTOSTART -------
----------------------
hl.on("hyprland.start", function()
    hl.exec_cmd(scripts .. "wallpaper.sh")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("gammastep -l geoclue2")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd(scripts .. "display-watch.sh")
end)

----------------------
---- ENV -------------
----------------------
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("MOZ_ENABLE_WAYLAND", "1")

----------------------
---- LOOK & INPUT ----
----------------------
local gaps_in, gaps_out = 6, 12

hl.config({
    general = {
        gaps_in     = gaps_in,
        gaps_out    = gaps_out,
        border_size = 2,
        col = {
            active_border   = { colors = { rgba(c.mauve), rgba(c.blue) }, angle = 45 },
            inactive_border = rgba(c.surface0, "aa"),
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding       = 12,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,
        shadow = {
            enabled      = true,
            range        = 18,
            render_power = 3,
            color        = 0xcc11111b,
        },
        blur = {
            enabled  = true,
            size     = 6,
            passes   = 3,
            vibrancy = 0.17,
            popups   = true,
        },
    },
    animations = { enabled = true },
    dwindle    = { preserve_split = true },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        background_color        = tonumber("0x" .. c.base),
    },
    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        touchpad = {
            tap_to_click   = true,
            natural_scroll = true,
        },
    },
})

-- Animations: windows appear instantly; subtle fades elsewhere
hl.curve("smooth", { type = "bezier", points = { {0.25, 1}, {0.5, 1} } })
hl.animation({ leaf = "windows",    enabled = false })   -- no open/close/move animation
hl.animation({ leaf = "border",     enabled = true, speed = 8, bezier = "smooth" })
hl.animation({ leaf = "fade",       enabled = true, speed = 5, bezier = "smooth" })
hl.animation({ leaf = "layers",     enabled = true, speed = 4, bezier = "smooth", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "smooth", style = "slide" })

----------------------
---- RULES -----------
----------------------
hl.window_rule({ name = "alacritty-opacity", match = { class = "^(Alacritty)$" }, opacity = "0.92 0.88" })
hl.window_rule({ name = "float-pavucontrol", match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true, size = "900 600", center = true })
hl.window_rule({ name = "float-nm-editor",   match = { class = "^(nm-connection-editor)$" },       float = true, center = true })
hl.window_rule({ name = "float-blueman",     match = { class = "^(blueman-manager)$" },            float = true, center = true })

-- Frosted glass behind the bar, launcher and notification center
for _, ns in ipairs({ "waybar", "rofi", "swaync-control-center", "swaync-notification-window" }) do
    hl.layer_rule({ name = "blur-" .. ns, match = { namespace = ns }, blur = true, ignore_alpha = 0.3 })
end

----------------------
---- KEYBINDS --------
----------------------
hl.bind(k("Return"),        exec(term))
hl.bind(k("SHIFT + Q"),     hl.dsp.window.close())
hl.bind(k("D"),             exec(menu))
hl.bind(k("V"),             exec("cliphist list | rofi -dmenu -p ' Clipboard' | cliphist decode | wl-copy"))
hl.bind(k("SHIFT + C"),     exec("hyprctl reload"))
hl.bind(k("SHIFT + E"),     exec(scripts .. "powermenu.sh"))
hl.bind(k("Escape"),        exec(scripts .. "powermenu.sh"))
hl.bind(k("SHIFT + X"),     exec("hyprlock"))
hl.bind(k("F"),             hl.dsp.window.fullscreen())
hl.bind(k("SHIFT + space"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(k("N"),             exec(scripts .. "nightlight.sh toggle"))
hl.bind(k("SHIFT + N"),     exec("swaync-client -t -sw"))
hl.bind(k("SHIFT + W"),     exec("pkill waybar || waybar"))

-- Screenshots
hl.bind("Print",    exec([[sh -c 'f=~/Pictures/screenshot-$(date +%F-%H%M%S).png; grim "$f" && notify-send -i "$f" "Screenshot saved" "$f"']]))
hl.bind(k("Print"), exec([[sh -c 'f=~/Pictures/screenshot-$(date +%F-%H%M%S).png; grim -g "$(slurp)" "$f" && wl-copy < "$f" && notify-send -i "$f" "Region copied" "$f"']]))
hl.bind(k("SHIFT + S"), exec("flameshot gui"))

-- Gaps (was $mod+[ / ] and Shift variants)
local function set_gaps()
    hl.config({ general = { gaps_in = gaps_in, gaps_out = gaps_out } })
end
hl.bind(k("bracketleft"),          function() gaps_in  = math.max(0, gaps_in - 2);  set_gaps() end)
hl.bind(k("bracketright"),         function() gaps_in  = gaps_in + 2;               set_gaps() end)
hl.bind(k("SHIFT + bracketleft"),  function() gaps_out = math.max(0, gaps_out - 2); set_gaps() end)
hl.bind(k("SHIFT + bracketright"), function() gaps_out = gaps_out + 2;              set_gaps() end)

-- Focus / move
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(k(dir),               hl.dsp.focus({ direction = dir }))
    hl.bind(k("SHIFT + " .. dir), hl.dsp.window.move({ direction = dir }))
end

-- Workspaces 1-5 (+ scroll through them)
for i = 1, 5 do
    hl.bind(k(tostring(i)),     hl.dsp.focus({ workspace = i }))
    hl.bind(k("SHIFT + " .. i), hl.dsp.window.move({ workspace = i }))
end
hl.bind(k("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(k("mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad
hl.bind(k("grave"),         hl.dsp.workspace.toggle_special("magic"))
hl.bind(k("SHIFT + grave"), hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse move/resize
hl.bind(k("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(k("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Resize mode (was $mod+r)
hl.bind(k("R"), hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("right",  hl.dsp.window.resize({ x = 20,  y = 0,   relative = true }), { repeating = true })
    hl.bind("left",   hl.dsp.window.resize({ x = -20, y = 0,   relative = true }), { repeating = true })
    hl.bind("up",     hl.dsp.window.resize({ x = 0,   y = -20, relative = true }), { repeating = true })
    hl.bind("down",   hl.dsp.window.resize({ x = 0,   y = 20,  relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Media keys (volume/brightness go through an OSD script so you get a popup)
local media = { locked = true, repeating = true }
hl.bind("XF86MonBrightnessUp",   exec(scripts .. "osd.sh bright-up"),   media)
hl.bind("XF86MonBrightnessDown", exec(scripts .. "osd.sh bright-down"), media)
hl.bind("XF86AudioRaiseVolume",  exec(scripts .. "osd.sh vol-up"),      media)
hl.bind("XF86AudioLowerVolume",  exec(scripts .. "osd.sh vol-down"),    media)
hl.bind("XF86AudioMute",         exec(scripts .. "osd.sh mute"),        { locked = true })
hl.bind("XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay",  exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  exec("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  exec("playerctl previous"),   { locked = true })
