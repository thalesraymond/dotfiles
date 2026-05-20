-- windowRules.lua
-- Window and layer rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

--------------------
---- TAGS ----------
--------------------

local tags = {
    ["+browser"] = {
        class = {
            "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
            "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
            "^(chrome-.+-Default)$",
            "^([Cc]hromium)$",
            "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
            "^(Brave-browser(-beta|-dev|-unstable)?)$",
            "^([Tt]horium-browser|[Cc]achy-browser)$",
            "^(zen-alpha|zen)$"
        }
    },
    ["+games"] = {
        class = {
            "^(gamescope)$",
            "^(steam_app_%d+)$",
            "^(rsi launcher.exe)$",
            "^(starcitizen.exe)$",
            "^(mtga.exe)$"
        }
    },
    ["+gamestore"] = {
        class = { "^([Ss]team)$", "^(com.heroicgameslauncher.hgl)$" },
        title = { "^([Ll]utris)$" }
    },
    ["+file-manager"] = {
        class = { "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$", "^(app.drey.Warp)$" }
    },
    ["+terminal"] = {
        class = { "^(Alacritty|kitty|kitty-dropterm|Ghostty)$" }
    },
    ["+email"] = {
        class = { "^([Tt]hunderbird|org.gnome.Evolution)$", "^(eu.betterbird.Betterbird)$" }
    },
    ["+projects"] = {
        class = { "^(codium|codium-url-handler|VSCodium)$", "^(VSCode|code-url-handler)$", "^(jetbrains-.+)$" }
    },
    ["+settings"] = {
        class = {
            "^(wihotspot(-gui)?)$",
            "^([Bb]aobab|org.gnome.[Bb]aobab)$",
            "^(gnome-disks|wihotspot(-gui)?)$",
            "^(file-roller|org.gnome.FileRoller)$",
            "^(nm-applet|nm-connection-editor|blueman-manager)$",
            "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
            "^(qt5ct|qt6ct|[Yy]ad)$",
            "(xdg-desktop-portal-gtk)",
            "^(org.kde.polkit-kde-authentication-agent-1)$",
            "^([Rr]ofi)$"
        },
        title = { "^(ROG Control)$", "(Kvantum Manager)" }
    },
    ["+viewer"] = {
        class = {
            "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
            "^(evince)$",
            "^(eog|org.gnome.Loupe)$"
        }
    }
}

for tag, matches in pairs(tags) do
    local tag_id = tag:sub(2)
    local i = 1
    for match_type, list in pairs(matches) do
        for _, pattern in ipairs(list) do
            hl.window_rule({
                name = "tag-" .. tag_id .. "-" .. i,
                tag = tag,
                match = { [match_type] = pattern }
            })
            i = i + 1
        end
    end
end

------------------------------
---- SPECIAL OVERRIDES -------
------------------------------

-- Disable blur and force full opacity for multimedia video
hl.window_rule({
    name    = "special-override-for-multimedia",
    no_blur = true,
    opacity = 1.0,
    match   = { tag = "multimedia_video*" },
})

-- Disable idle inhibit for fullscreen apps
hl.window_rule({
    name         = "disable-idle-on-fullscreen",
    idle_inhibit = "fullscreen",
    match        = { fullscreen = true },
})

-----------------------------
---- WORKSPACE ASSIGNMENTS --
-----------------------------

local workspace_assignments = {
    { name = "gamestore", workspace = "1 silent", match = { tag = "gamestore*" } },
    { name = "messaging", workspace = "9 silent", opacity = "0.94 override",     match = { tag = "im*" } },
    {
        name = "games",
        workspace = "1",
        no_blur = true,
        fullscreen = true,
        idle_inhibit = "always",
        confine_pointer = true,
        match = { tag = "games*" }
    },
    { name = "multimedia", workspace = "9 silent", opacity = "0.94 override", match = { tag = "multimedia*" } },
}

for _, rule in ipairs(workspace_assignments) do
    rule.name = "workspace-" .. rule.name
    hl.window_rule(rule)
end

--------------------
---- FLOAT DIALOGS --
--------------------

local float_dialogs = {
    { name = "dialogs",           center = true,                                                                                           match = { title = "^(Authentication Required)$" } },
    { name = "dialogs-vs-code",   match = { class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" } },
    { name = "dialogs-3",         match = { class = "^(com.heroicgameslauncher.hgl)$", title = "negative:(Heroic Games Launcher)" } },
    { name = "dialogs-steam",     match = { class = "^([Ss]team)$", title = "negative:^([Ss]team)$" } },
    { name = "dialogs-thunar",    match = { class = "([Tt]hunar)", title = "negative:(.*[Tt]hunar.*)" } },
    { name = "dialogs-4",         size = { "monitor_w*0.7", "monitor_h*0.6" },                                                             center = true,                                    match = { title = "^(Add Folder to Workspace)$" } },
    { name = "dialog-save-as",    size = { "monitor_w*0.7", "monitor_h*0.6" },                                                             center = true,                                    match = { title = "^(Save As)$" } },
    { name = "dialog-open-files", size = { "monitor_w*0.7", "monitor_h*0.6" },                                                             match = { initial_title = "(Open Files)" } }
}

for _, dialog in ipairs(float_dialogs) do
    dialog.float = true
    hl.window_rule(dialog)
end

-----------------
---- OPACITY ----
-----------------

-- Opacities use "override" so they are absolute values, not multipliers stacked
-- on top of decoration.active_opacity / decoration.inactive_opacity.
local tag_opacities = {
    ["browser*"]      = "0.96 override",
    ["projects*"]     = "0.98 override",
    ["file-manager*"] = "0.9 override",
    ["terminal*"]     = "0.8 override",
    ["settings*"]     = "0.8 override",
    ["viewer*"]       = "0.82 override",
    ["wallpaper*"]    = "0.9 override",
}
for tag, op in pairs(tag_opacities) do
    hl.window_rule({ name = "blur-" .. tag:gsub("%*", ""), opacity = op, match = { tag = tag } })
end

local class_opacities = {
    ["^(gedit|org.gnome.TextEditor|mousepad)$"] = "0.8 override",
    ["^(deluge)$"]                              = "0.9 override",
    ["^(seahorse)$"]                            = "0.9 override",
    ["^(code)$"]                                = "0.97 override",
}
for class, op in pairs(class_opacities) do
    -- Generate a safe string name
    local name = class:gsub("[%^%$%(%)|]", ""):sub(1, 15)
    hl.window_rule({ name = "blur-" .. name, opacity = op, match = { class = class } })
end

---------------------------
---- PICTURE-IN-PICTURE ----
---------------------------

-- Step 1: Force it to HDMI output via workspace BEFORE pinning
hl.window_rule({
    name      = "rule-for-pip-output",
    workspace = "9 silent",
    float     = true,
    match     = { title = "^(Picture-in-Picture)$" },
})

-- Step 2: Size, position, and pin the window
hl.window_rule({
    name              = "rule-for-pip-state",
    opaque            = true,
    keep_aspect_ratio = true,
    size              = { 1219, 686 },
    pin               = true,
    move              = { "monitor_w - window_w - 50", "monitor_h - window_h - 50" },
    match             = { title = "^(Picture-in-Picture)$" },
})

--------------------------
---- JETBRAINS FOCUS -----
--------------------------

-- Avoid stealing focus for IntelliJ Products' popup windows
-- Note: RE2 uses .+ not glob-style *, so jetbrains-.+ means "jetbrains-" followed by one or more chars
hl.window_rule({ name = "windowrule-67", no_initial_focus = true, match = { class = "^(jetbrains-.+)" } })
hl.window_rule({ name = "windowrule-68", no_initial_focus = true, match = { title = "^(wind.*)$" } })

----------------------------
---- APP WORKSPACE RULES ----
----------------------------

local app_workspaces = {
    { ws = "9 silent", class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" },
    { ws = "9 silent", class = "^(com.github.th_ch.youtube_music)$" },
    { ws = "9 silent", class = "^([Dd]iscord)$" },
    { ws = "9 silent", class = "^([Ss]potify)$" },
    { ws = "9 silent", class = "^([Tt]hunderbird)$" },
    { ws = "2",        maximize = true,                                             class = "^(zen-alpha|zen)$", title = "negative:^(Picture-in-Picture)$" },
}
for i, app in ipairs(app_workspaces) do
    local match = { class = app.class }
    if app.title then match.title = app.title end

    local rule = { name = "app-workspace-" .. i, workspace = app.ws, match = match }
    if app.maximize then rule.maximize = true end
    hl.window_rule(rule)
end

-------------------------------
---- GLOBAL / SYSTEM RULES ----
-------------------------------

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
    name           = "supress_maximize_requests",
    suppress_event = "maximize",
    match          = { class = ".*" },
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name     = "windowrule-2",
    no_focus = true,
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
})

-----------------------
---- LAYER RULES ------
-----------------------

-- Blur on DMS bar
hl.layer_rule({
    name  = "layerrule-1",
    blur  = true,
    match = { namespace = "dms:bar" },
})
