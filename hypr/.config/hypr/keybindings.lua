-- keybindings.lua
-- Key bindings configuration
-- https://wiki.hypr.land/Configuring/Basics/Binds/
--
-- Niri-style bindings for the native scrolling layout, with dwindle fallbacks.
-- Whole-column transfers, workspace reordering, and window-height presets do
-- not have native scrolling dispatchers; transfers below move one window.

local mainMod    = "SUPER"
local term       = "kitty"
local files      = "thunar"
-- Resolve the workspace layout when pressed, including workspace overrides.
-- Floating windows retain normal directional navigation and resizing.
local function layout_cmd(fallback, scrolling_cmd)
    return function()
        local workspace = hl.get_active_workspace()
        local window = hl.get_active_window()
        local layout = workspace and workspace.tiled_layout or hl.get_config("general.layout")
        if layout == "scrolling" and window and not window.floating then
            hl.dispatch(hl.dsp.layout(scrolling_cmd))
        elseif fallback then
            hl.dispatch(fallback)
        end
    end
end

---------------------
---- APPLICATION ----
---------------------

local apps = {
    { "SPACE",          hl.dsp.exec_cmd("dms ipc call spotlight toggle") },
    { "Return",         hl.dsp.exec_cmd(term) },
    { "SHIFT + Return", hl.dsp.exec_cmd("[float; move 15% 5%; size 70% 60%] " .. term) },
    { "E",              hl.dsp.exec_cmd(files) },
    { "B",              hl.dsp.exec_cmd('xdg-open "https://"') },
    { "SHIFT + W",      hl.dsp.exec_cmd("dms ipc call wallpaperCarousel toggle") },
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

    -- Keep Shift+I available: Niri uses it to reorder workspaces.
    { "ALT + I", layout_cmd(hl.dsp.layout("togglesplit"), "inhibit_scroll") },
}
for _, bind in ipairs(win_binds) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2])
end
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + V", function()
    local window = hl.get_active_window()
    if not window then return end
    hl.dispatch(hl.dsp.window.cycle_next({ floating = not window.floating, tiled = window.floating }))
end)

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
        -- Niri uses Up/Down for workspaces, K/J for windows in a column.
        if key ~= "up" and key ~= "down" then
            hl.bind(mainMod .. " + " .. key,
                layout_cmd(hl.dsp.focus({ direction = dir }), "focus " .. dir))
        end

        -- Horizontal moves swap whole columns; vertical moves reorder windows.
        local move = hl.dsp.window.move({ direction = dir })
        if dir == "l" or dir == "r" then
            move = layout_cmd(move, "swapcol " .. dir)
        end
        hl.bind(mainMod .. " + CTRL + " .. key, move, { repeating = true })

        -- Swap windows
        hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.swap({ direction = dir }))

        -- Focus monitor
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.focus({ monitor = dir }))

        -- Move window to monitor
        hl.bind(mainMod .. " + SHIFT + CTRL + " .. key, hl.dsp.window.move({ monitor = dir }))
    end
end

-----------------------------
---- COLUMNS / RESIZE --------
-----------------------------

-- Percentages are fractions of the scrolling viewport; other layouts and
-- floating windows use 50 logical pixel steps. Shift+arrows focus monitors.
local resize_binds = {
    { "minus", layout_cmd(hl.dsp.window.resize({ x = -50, y = 0, relative = true }), "colresize -0.1") },
    { "equal", layout_cmd(hl.dsp.window.resize({ x = 50, y = 0, relative = true }), "colresize +0.1") },
    { "SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -50, relative = true }) },
    { "SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 50, relative = true }) },
}
for _, bind in ipairs(resize_binds) do
    hl.bind(mainMod .. " + " .. bind[1], bind[2], { repeating = true })
end

local column_binds = {
    { "bracketleft", "consume_or_expel prev" },
    { "bracketright", "consume_or_expel next" },
    { "comma", "consume" },
    { "period", "expel" },
    { "R", "colresize +conf" },
    { "C", "center" },
    { "CTRL + F", "fit expand" },
}
for _, bind in ipairs(column_binds) do
    hl.bind(mainMod .. " + " .. bind[1], layout_cmd(nil, bind[2]))
end

-- Native scrolling has no first/last-column dispatcher. Focus an endpoint
-- by its position on the tape; windows within a column share their x position.
local function focus_endpoint(last)
    return function()
        local workspace = hl.get_active_workspace()
        if not workspace or workspace.tiled_layout ~= "scrolling" then return end
        local endpoint
        for _, window in ipairs(hl.get_workspace_windows(workspace)) do
            if window.mapped and not window.hidden and not window.floating then
                if not endpoint or (last and window.at.x > endpoint.at.x)
                    or (not last and window.at.x < endpoint.at.x) then
                    endpoint = window
                end
            end
        end
        if endpoint then hl.dispatch(hl.dsp.focus({ window = endpoint })) end
    end
end
hl.bind(mainMod .. " + Home", focus_endpoint(false))
hl.bind(mainMod .. " + End", focus_endpoint(true))

-- Niri's Ctrl+Home/End, Shift+R, Ctrl+R, Ctrl+C and Shift+Page_Up/Down
-- have no direct equivalents. "fit visible" resizes columns rather than
-- merely centering them, so it is deliberately not bound to Ctrl+C.

hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("pkill orca || exec orca"))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

------------------------
---- WORKSPACES --------
------------------------

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9].
-- Unlike Niri, this moves one window rather than its whole column.
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace Navigation
local ws_nav = {
    ["m+1"] = { "down", "Page_Down", "U", "mouse_down" },
    ["m-1"] = { "up", "Page_Up", "I", "mouse_up" }
}
for ws, keys in pairs(ws_nav) do
    for _, key in ipairs(keys) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    end
end

-- Move window to adjacent workspace
local ws_move = {
    ["m+1"] = { "Page_Down", "U", "mouse_down" },
    ["m-1"] = { "Page_Up", "I", "mouse_up" }
}
for ws, keys in pairs(ws_move) do
    for _, key in ipairs(keys) do
        hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = ws }))
    end
end

-- Horizontal wheel and Shift+vertical wheel navigate/reorder columns.
for dir, keys in pairs({ l = { "mouse_left", "SHIFT + mouse_up" },
                        r = { "mouse_right", "SHIFT + mouse_down" } }) do
    for _, key in ipairs(keys) do
        hl.bind(mainMod .. " + " .. key, layout_cmd(hl.dsp.focus({ direction = dir }), "focus " .. dir))
        hl.bind(mainMod .. " + CTRL + " .. key,
            layout_cmd(hl.dsp.window.move({ direction = dir }), "swapcol " .. dir))
    end
end
-- Hyprland uses a global wheel cooldown instead of Niri's per-bind cooldown.
hl.config({ binds = { scroll_event_delay = 150 } })

------------------
---- UTILS -------
------------------

-- local screenshot_binds = {
--     { "Print",         hl.dsp.exec_cmd("dms screenshot") },
--     { "CTRL + Print",  hl.dsp.exec_cmd("dms screenshot full") },
--     { "ALT + Print",   hl.dsp.exec_cmd("dms screenshot scroll") },
--     { "SHIFT + Print", hl.dsp.exec_cmd("dms screenshot --no-file") },
-- }
-- for _, bind in ipairs(screenshot_binds) do
--     hl.bind(mainMod .. " + " .. bind[1], bind[2])
-- end

hl.bind("Print",
    hl.dsp.exec_cmd(
        'grim -g "$(slurp)" - | satty -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png"'))

local utils_binds = {
    { "ALT + L", hl.dsp.exec_cmd("swaylock --clock --effect-blur 7x5 --fade-in 0.2 --indicator") },
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
-- Resolve the plugin at keypress: hyprpm loads it after config evaluation.
local function toggle_overview()
    if hl.plugin.hymission then hl.plugin.hymission.toggle() end
end
hl.bind(mainMod .. " + O", toggle_overview)
hl.bind(mainMod .. " + TAB", toggle_overview)
hl.bind("mouse:275", toggle_overview)
