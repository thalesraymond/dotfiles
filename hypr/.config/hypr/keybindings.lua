-- keybindings.lua
-- Key bindings configuration
-- https://wiki.hypr.land/Configuring/Basics/Binds/
--
-- Layout-aware: works with both "dwindle" and "scrolling" layouts.
-- Resize/navigation adapts based on the active layout at runtime.

local mainMod    = "SUPER"
local term       = "ghostty"
local files      = "thunar"
local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Helper: build a shell one-liner that checks the current layout
-- and dispatches accordingly.
local function layout_cmd(dwindle_cmd, scrolling_cmd)
    return hl.dsp.exec_cmd(
        'LAYOUT=$(hyprctl getoption general:layout -j | jq -r .str);'
        .. ' if [ "$LAYOUT" = "scrolling" ]; then'
        .. '   hyprctl dispatch ' .. scrolling_cmd .. ';'
        .. ' else'
        .. '   hyprctl dispatch ' .. scrolling_cmd .. ' 2>/dev/null'
        .. '   || hyprctl dispatch ' .. dwindle_cmd .. ';'
        .. ' fi'
    )
end

---------------------
---- APPLICATION ----
---------------------

local apps       = {
    { "SPACE",          hl.dsp.exec_cmd("dms ipc call spotlight toggle") },
    { "Return",         hl.dsp.exec_cmd(term) },
    { "SHIFT + Return", hl.dsp.exec_cmd("[float; move 15% 5%; size 70% 60%] " .. term) },
    { "E",              hl.dsp.exec_cmd(files) },
    { "B",              hl.dsp.exec_cmd('xdg-open "https://"') },
}
for _, bind in ipairs(apps) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2])
end

------------------
---- WINDOWS ----
------------------

local win_binds = {
    { "Q",         hl.dsp.window.close() },
    { "SHIFT + Q", hl.dsp.window.kill() },
    { "SHIFT + F", hl.dsp.window.fullscreen() },
    { "F",         hl.dsp.window.fullscreen({ mode = "maximized" }) },
    { "V",         hl.dsp.window.float({ action = "toggle" }) },

    -- Dwindle: toggle split direction | Scrolling: no-op (harmless)
    { "SHIFT + I", hl.dsp.layout("togglesplit") },
}
for _, bind in ipairs(win_binds) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2])
end
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())

-- Groups (works on either layout)
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind(mainMod .. " + CTRL + TAB", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive"))

-- Cycle windows (float-friendly ALT+Tab)
hl.bind("ALT + TAB", hl.dsp.exec_cmd("hyprctl dispatch cyclenext && hyprctl dispatch bringactivetotop"))

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
        -- Focus windows in all directions
        -- (dwindle uses all 4; scrolling mainly uses left/right but up/down still work)
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))

        -- Move windows
        hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ direction = dir }), { repeating = true })

        -- Swap windows
        hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.swap({ direction = dir }))

        -- Focus monitor
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.focus({ monitor = dir }))

        -- Move window to monitor
        hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ monitor = dir }))
    end
end

-----------------------------
---- RESIZE (layout-aware) --
-----------------------------

-- Horizontal resize:
--   Scrolling → colresize (column width)
--   Dwindle   → resizeactive (pixel-based)
local resize_binds = {
    { "minus",         layout_cmd("resizeactive -50 0", "layoutmsg colresize -0.1"),  { repeating = true } },
    { "equal",         layout_cmd("resizeactive 50 0",  "layoutmsg colresize +0.1"),  { repeating = true } },
}
for _, bind in ipairs(resize_binds) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2], bind[3])
end

-- Vertical resize (same on both layouts — pixel-based)
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -50 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 50 }),  { repeating = true })

-- Fit column to screen (scrolling-only, harmless no-op on dwindle)
hl.bind(mainMod .. " + C", hl.dsp.layout("fit"))

-- Split ratio (dwindle: adjust split, scrolling: harmless)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch splitratio 0.3"))

hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("pkill orca || exec orca"))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

------------------------
---- WORKSPACES --------
------------------------

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace Navigation
local ws_nav = {
    ["e+1"] = { "Page_Down", "U", "period", "mouse_down" },
    ["e-1"] = { "Page_Up", "I", "comma", "mouse_up" }
}
for ws, keys in pairs(ws_nav) do
    for _, key in ipairs(keys) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    end
end

-- Move window to adjacent workspace
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
    { "P",         hl.dsp.exec_cmd('HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m output') },
    { "SHIFT + P", hl.dsp.exec_cmd('HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m region') },
    { "CTRL + P",  hl.dsp.exec_cmd('HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m window') },
    { "ALT + L",   hl.dsp.exec_cmd("swaylock") },
}
for _, bind in ipairs(utils_binds) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2])
end

----------------------
---- MEDIA KEYS ------
----------------------

local media_binds = {
    { "XF86AudioRaiseVolume",  hl.dsp.exec_cmd("dms ipc call audio increment 5"), { locked = true, repeating = true } },
    { "XF86AudioLowerVolume",  hl.dsp.exec_cmd("dms ipc call audio decrement 5"), { locked = true, repeating = true } },
    { "XF86AudioMute",         hl.dsp.exec_cmd("dms ipc call audio mute"),        { locked = true, repeating = true } },
    { "XF86AudioMicMute",      hl.dsp.exec_cmd("dms ipc call audio micmute"),     { locked = true, repeating = true } },
    { "XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),  { locked = true, repeating = true } },
    { "XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),  { locked = true, repeating = true } },
    { "XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),                 { locked = true } },
    { "XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),           { locked = true } },
    { "XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),           { locked = true } },
    { "XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),             { locked = true } },
}
for _, bind in ipairs(media_binds) do
    hl.bind(bind[1], bind[2], bind[3])
end

----------------------
----- HYMISSION-------
----------------------
hl.bind(mainMod .. " + TAB", hl.plugin.hymission.toggle)
hl.bind("mouse:275", hl.plugin.hymission.toggle)
