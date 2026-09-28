-- ~/.config/hypr/hyprland.lua — port of Rishu's Sway config (Hyprland 0.55+ Lua config)

----------------------
---- VARIABLES -------
----------------------
local mod  = "SUPER"
local term = "alacritty"
local menu = "rofi -show drun"

local function k(keys) return mod .. " + " .. keys end
local exec = hl.dsp.exec_cmd

----------------------
---- MONITORS --------
----------------------
-- eDP-1 gets disabled automatically by scripts/display-watch.sh when an external screen is plugged in
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = "1" })
hl.monitor({ output = "eDP-1",    mode = "preferred", position = "auto", scale = "1" })
hl.monitor({ output = "",         mode = "preferred", position = "auto", scale = "1" })

----------------------
---- AUTOSTART -------
----------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("dex --autostart --environment Hyprland")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("pasystray")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaybg -i ~/Pictures/wallpaper.jpg -m fill")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("gammastep -l geoclue2")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("~/.config/hypr/scripts/display-watch.sh")
end)

----------------------
---- ENV -------------
----------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GTK_THEME", "Materia-dark")

----------------------
---- LOOK & INPUT ----
----------------------
local gaps_in, gaps_out = 5, 10

hl.config({
    general = {
        gaps_in     = gaps_in,
        gaps_out    = gaps_out,
        border_size = 2,
        col = {
            active_border   = "rgba(89b4faee)",
            inactive_border = "rgba(45475aaa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        blur = { enabled = true, size = 6, passes = 2 },
    },
    animations = { enabled = true },
    dwindle    = { preserve_split = true },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
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

----------------------
---- WINDOW RULES ----
----------------------
-- was: for_window [app_id="Alacritty"] opacity 0.92
hl.window_rule({
    name    = "alacritty-opacity",
    match   = { class = "^(Alacritty)$" },
    opacity = "0.92 0.92",
})

----------------------
---- KEYBINDS --------
----------------------
hl.bind(k("Return"),        exec(term))
hl.bind(k("SHIFT + Q"),     hl.dsp.window.close())
hl.bind(k("D"),             exec(menu))
hl.bind(k("V"),             exec("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(k("SHIFT + C"),     hl.dsp.reload_config())
hl.bind(k("SHIFT + E"),     hl.dsp.exit())
hl.bind(k("SHIFT + X"),     exec("hyprlock"))
hl.bind(k("F"),             hl.dsp.window.fullscreen())
hl.bind(k("SHIFT + space"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(k("N"),             exec("pkill gammastep || gammastep -l geoclue2"))

-- Screenshots
hl.bind("Print",    exec([[grim ~/Pictures/screenshot-$(date +%F-%H%M%S).png]]))
hl.bind(k("Print"), exec([[sh -c 'f=~/Pictures/screenshot-$(date +%F-%H%M%S).png; grim -g "$(slurp)" "$f" && wl-copy < "$f"']]))
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
    hl.bind(k(dir),             hl.dsp.focus({ direction = dir }))
    hl.bind(k("SHIFT + " .. dir), hl.dsp.window.move({ direction = dir }))
end

-- Workspaces 1-5
for i = 1, 5 do
    hl.bind(k(tostring(i)),           hl.dsp.focus({ workspace = i }))
    hl.bind(k("SHIFT + " .. i),       hl.dsp.window.move({ workspace = i }))
end

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

-- Media keys
local media = { locked = true, repeating = true }
hl.bind("XF86MonBrightnessUp",   exec("brightnessctl set 5%+"), media)
hl.bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), media)
hl.bind("XF86AudioRaiseVolume",  exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), media)
hl.bind("XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), media)
hl.bind("XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
