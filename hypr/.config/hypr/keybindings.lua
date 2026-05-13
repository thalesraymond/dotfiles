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

-- Launcher (DMS Material Shell)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))

-- Terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term))

-- Floating Terminal
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("[float; move 15% 5%; size 70% 60%] " .. term))

-- File Manager
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(files))

-- Default Browser
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd('xdg-open "https://"'))

------------------
---- WINDOWS ----
------------------

-- Close active window
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Kill active window (force)
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(
    "kill $(hyprctl activewindow | grep -o 'pid: [0-9]*' | cut -d' ' -f2)"))

-- Fullscreen
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = 1 })) -- fake/maximized

-- Toggle floating
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Toggle split (horizontal/vertical) — dwindle
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))

-- Exit
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())

---------------------
---- FOCUS / NAV ----
---------------------

-- Universal focus (Niri style: HJKL and arrows)
hl.bind(mainMod .. " + left",  hl.dsp.exec_cmd(scriptsDir .. "/focus_window.sh l"))
hl.bind(mainMod .. " + right", hl.dsp.exec_cmd(scriptsDir .. "/focus_window.sh r"))
hl.bind(mainMod .. " + H",     hl.dsp.exec_cmd(scriptsDir .. "/focus_window.sh l"))
hl.bind(mainMod .. " + L",     hl.dsp.exec_cmd(scriptsDir .. "/focus_window.sh r"))
hl.bind(mainMod .. " + J",     hl.dsp.exec_cmd(scriptsDir .. "/focus_window.sh d"))
hl.bind(mainMod .. " + K",     hl.dsp.exec_cmd(scriptsDir .. "/focus_window.sh u"))

-- Move/swap windows
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "d" }))

-- Move windows (layout-aware, Niri style)
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh l"), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh r"), { repeating = true })
hl.bind(mainMod .. " + CTRL + H",     hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh l"), { repeating = true })
hl.bind(mainMod .. " + CTRL + L",     hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh r"), { repeating = true })
hl.bind(mainMod .. " + CTRL + J",     hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh d"), { repeating = true })
hl.bind(mainMod .. " + CTRL + K",     hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh u"), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh d"), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.exec_cmd(scriptsDir .. "/move_window.sh u"), { repeating = true })

-- Resize windows (regular tiling)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50,  y = 0 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0,   y = -50 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0,   y = 50 }),  { repeating = true })

-- Resize windows (Scrolling layout, Niri style)
hl.bind(mainMod .. " + minus",         hl.dsp.layout("colresize -0.1"), { repeating = true })
hl.bind(mainMod .. " + equal",         hl.dsp.layout("colresize +0.1"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -50 }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 50 }),  { repeating = true })
hl.bind(mainMod .. " + C",             hl.dsp.layout("togglefit"))

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
hl.bind(mainMod .. " + down",      hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + up",        hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Page_Up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + U",         hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + I",         hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period",    hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma",     hl.dsp.focus({ workspace = "e-1" }))

-- Scroll workspaces with mouse wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move window to adjacent workspace (Niri style)
hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + Page_Up",   hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + U",         hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + I",         hl.dsp.window.move({ workspace = "e-1" }))

------------------
---- UTILS -------
------------------

-- Screenshot
hl.bind(mainMod .. " + P",         hl.dsp.exec_cmd(
    'HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m output'))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(
    'HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m region'))
hl.bind(mainMod .. " + CTRL + P",  hl.dsp.exec_cmd(
    'HYPRSHOT_DIR="$HOME/Pictures/Screenshots" hyprshot -m window'))

-- Lock screen
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("swaylock"))

----------------------
---- MEDIA KEYS ------
----------------------

-- Volume controls (via DMS)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("dms ipc call audio mute"),         { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("dms ipc call audio micmute"),      { locked = true, repeating = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media (requires playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
