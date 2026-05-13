-- keybindings.lua
-- Key bindings configuration
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod    = "SUPER"
local term       = "ghostty"
local files      = "thunar"
local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

---------------------
---- APPLICATION ----
---------------------

local apps = {
    { "SPACE", hl.dsp.exec_cmd("dms ipc call spotlight toggle") },
    { "Return", hl.dsp.exec_cmd(term) },
    { "SHIFT + Return", hl.dsp.exec_cmd("[float; move 15% 5%; size 70% 60%] " .. term) },
    { "E", hl.dsp.exec_cmd(files) },
    { "B", hl.dsp.exec_cmd('xdg-open "https://"') },
}
for _, bind in ipairs(apps) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2])
end

------------------
---- WINDOWS ----
------------------

local win_binds = {
    { "Q", hl.dsp.window.close() },
    { "SHIFT + Q", hl.dsp.window.kill() },
    { "SHIFT + F", hl.dsp.window.fullscreen() },
    { "F", hl.dsp.window.fullscreen({ mode = "maximized" }) },
    { "V", hl.dsp.window.float({ action = "toggle" }) },
    { "SHIFT + I", hl.dsp.layout("togglesplit") },
}
for _, bind in ipairs(win_binds) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2])
end
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())

---------------------
---- FOCUS / NAV ----
---------------------

local dir_keys = {
    l = { "left", "H" },
    r = { "right", "L" },
    u = { "up", "K" },
    d = { "down", "J" }
}

for dir, keys in pairs(dir_keys) do
    for _, key in ipairs(keys) do
        -- Focus windows (skip Up/Down arrows since they are reserved for workspaces)
        if key ~= "up" and key ~= "down" then
            hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
        end
        
        -- Move windows
        hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ direction = dir }), { repeating = true })
        
        -- Move/swap windows
        hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.swap({ direction = dir }))
        
        -- Focus monitor
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.focus({ monitor = dir }))
        
        -- Move window to monitor
        hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ monitor = dir }))
    end
end

-- Resize windows (Scrolling layout, Niri style)
local scroll_resize = {
    { "minus", hl.dsp.layout("colresize -0.1"), { repeating = true } },
    { "equal", hl.dsp.layout("colresize +0.1"), { repeating = true } },
    { "SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -50 }), { repeating = true } },
    { "SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 50 }), { repeating = true } },
    { "C", hl.dsp.layout("togglefit") }
}
for _, bind in ipairs(scroll_resize) do
    if bind[3] then
        hl.bind(mainMod .. " + " .. bind[1], bind[2], bind[3])
    else
        hl.bind(mainMod .. " + " .. bind[1], bind[2])
    end
end

hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("pkill orca || exec orca"))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

------------------------
---- WORKSPACES --------
------------------------

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace Navigation (Niri style)
local ws_nav = {
    ["e+1"] = { "down", "Page_Down", "U", "period", "mouse_down" },
    ["e-1"] = { "up", "Page_Up", "I", "comma", "mouse_up" }
}
for ws, keys in pairs(ws_nav) do
    for _, key in ipairs(keys) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    end
end

-- Move window to adjacent workspace (Niri style)
local ws_move = {
    ["e+1"] = { "Page_Down", "U" },
    ["e-1"] = { "Page_Up", "I" }
}
for ws, keys in pairs(ws_move) do
    for _, key in ipairs(keys) do
        hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = ws }))
    end
end

------------------
---- UTILS -------
------------------

local utils_binds = {
    { "P", hl.dsp.exec_cmd('HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m output') },
    { "SHIFT + P", hl.dsp.exec_cmd('HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m region') },
    { "CTRL + P", hl.dsp.exec_cmd('HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m window') },
    { "ALT + L", hl.dsp.exec_cmd("swaylock") },
}
for _, bind in ipairs(utils_binds) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2])
end

----------------------
---- MEDIA KEYS ------
----------------------

local media_binds = {
    { "XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 5"), { locked = true, repeating = true } },
    { "XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 5"), { locked = true, repeating = true } },
    { "XF86AudioMute",        hl.dsp.exec_cmd("dms ipc call audio mute"),         { locked = true, repeating = true } },
    { "XF86AudioMicMute",     hl.dsp.exec_cmd("dms ipc call audio micmute"),      { locked = true, repeating = true } },
    { "XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true } },
    { "XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true } },
    { "XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),       { locked = true } },
    { "XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
    { "XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
    { "XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),   { locked = true } },
}
for _, bind in ipairs(media_binds) do
    hl.bind(bind[1], bind[2], bind[3])
end
