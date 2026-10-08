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
-- Display mode is picked with Super+P (scripts/display-mode.sh), which writes
-- laptop | external | both | mirror to ~/.cache/hypr-display-mode and reloads.
-- Applying it through a full reload is what reliably turns screens back ON.
local LAPTOP    = "eDP-1"
local MODE_FILE = os.getenv("HOME") .. "/.cache/hypr-display-mode"

local function read_mode()
    local f = io.open(MODE_FILE, "r")
    if not f then return "both" end
    local m = f:read("l") or "both"
    f:close()
    return m
end

local function write_mode(m)
    local f = io.open(MODE_FILE, "w")
    if f then f:write(m) f:close() end
end

local MODE   = read_mode()
local ON     = { mode = "preferred", scale = "1" }
local function mon(t) for k, v in pairs(ON) do if t[k] == nil then t[k] = v end end hl.monitor(t) end

-- "" = every external screen; the laptop rule is added last so it wins for eDP-1
if MODE == "laptop" then
    hl.monitor({ output = "", disabled = true })
    mon({ output = LAPTOP, position = "0x0" })
elseif MODE == "external" then
    mon({ output = "", position = "auto" })
    hl.monitor({ output = LAPTOP, disabled = true })
elseif MODE == "mirror" then
    mon({ output = "", position = "auto", mirror = LAPTOP })
    mon({ output = LAPTOP, position = "0x0" })
else -- both
    mon({ output = "", position = "auto-right" })
    mon({ output = LAPTOP, position = "0x0" })
end

local function is_external(name, ignore)
    return name ~= LAPTOP and name ~= ignore
        and name ~= "FALLBACK" and not name:match("^HEADLESS")
end

-- Safety: if the last external screen is unplugged while the laptop is off,
-- fall back to "both" so you never end up with a dark laptop.
hl.on("monitor.removed", function(m)
    if MODE ~= "external" or not is_external(m.name) then return end
    for _, o in ipairs(hl.get_monitors()) do
        if is_external(o.name, m.name) then return end
    end
    write_mode("both")
    hl.exec_cmd("hyprctl reload")
end)

-- Every login starts in "both"
hl.on("hyprland.start", function()
    if MODE ~= "both" then
        write_mode("both")
        hl.exec_cmd("hyprctl reload")
    end
end)

hl.bind("SUPER + P", hl.dsp.exec_cmd(scripts .. "display-mode.sh"))

----------------------
---- AUTOSTART -------
----------------------
hl.on("hyprland.start", function()
    hl.exec_cmd(scripts .. "wallpaper.sh")
    hl.exec_cmd(scripts .. "waybar.sh")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("gammastep -l geoclue2")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
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
        -- every window is slightly see-through so the blur shows behind it
        active_opacity   = 0.92,
        inactive_opacity = 0.85,
        shadow = {
            enabled      = true,
            range        = 18,
            render_power = 3,
            color        = 0xcc11111b,
        },
        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            new_optimizations = true,
            noise             = 0.02,
            contrast          = 1.0,
            brightness        = 0.9,
            vibrancy          = 0.2,
            popups            = true,
        },
    },
    animations = { enabled = true },
    dwindle    = { preserve_split = true },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        allow_session_lock_restore = true,  -- if hyprlock crashes, it can be restarted from a TTY
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
-- Keep these fully opaque: video/images/games look wrong see-through, and
-- Alacritty already has its own transparent background (text stays crisp)
hl.window_rule({
    name   = "opaque-media",
    match  = { class = "^(mpv|vlc|imv|org.gnome.Loupe|steam_app_.*|gamescope|Alacritty)$" },
    opaque = true,
})
hl.window_rule({ name = "opaque-fullscreen", match = { fullscreen = true }, opaque = true })
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
hl.bind(k("L"),     exec("hyprlock"))
hl.bind(k("F"),             hl.dsp.window.fullscreen())
hl.bind(k("SHIFT + space"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(k("N"),             exec(scripts .. "nightlight.sh toggle"))
hl.bind(k("SHIFT + N"),     exec("swaync-client -t -sw"))
hl.bind(k("SHIFT + W"),     exec("pkill -x waybar || " .. scripts .. "waybar.sh"))

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

-- i3-style splits: choose where the NEXT window opens
hl.bind(k("H"),         hl.dsp.layout("preselect d"))   -- next window opens below (stacked)
hl.bind(k("SHIFT + H"), hl.dsp.layout("preselect r"))   -- next window opens to the right
hl.bind(k("J"),         hl.dsp.layout("togglesplit"))   -- flip current pair: side-by-side <-> stacked

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
