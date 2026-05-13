-- windowRules.lua
-- Window and layer rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

--------------------
---- TAGS ----------
--------------------

-- Browser tags
hl.window_rule({ name = "tag-browsers-firefox", tag = "+browser",
    match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" } })
hl.window_rule({ name = "tag-browsers-chrome", tag = "+browser",
    match = { class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" } })
hl.window_rule({ name = "tag-browsers-chrome-2", tag = "+browser",
    match = { class = "^(chrome-.+-Default)$" } }) -- Chrome PWAs
hl.window_rule({ name = "tag-browsers-chrome-3", tag = "+browser",
    match = { class = "^([Cc]hromium)$" } })
hl.window_rule({ name = "tag-browsers-edge", tag = "+browser",
    match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" } })
hl.window_rule({ name = "tag-browsers-brave", tag = "+browser",
    match = { class = "^(Brave-browser(-beta|-dev|-unstable)?)$" } })
hl.window_rule({ name = "tag-browsers-thorium", tag = "+browser",
    match = { class = "^([Tt]horium-browser|[Cc]achy-browser)$" } })
hl.window_rule({ name = "tag-browsers-zen", tag = "+browser",
    match = { class = "^(zen-alpha|zen)$" } })

-- Game tags
hl.window_rule({ name = "tag-games", tag = "+games",
    match = { class = "^(gamescope)$" } })
hl.window_rule({ name = "tag-games-2", tag = "+games",
    match = { class = "^(steam_app_%d+)$" } })
hl.window_rule({ name = "tag-games-3", tag = "+games",
    match = { class = "^(rsi launcher.exe)$" } })
hl.window_rule({ name = "tag-games-4", tag = "+games",
    match = { class = "^(starcitizen.exe)$" } })
hl.window_rule({ name = "tag-games-5", tag = "+games",
    match = { class = "^(mtga.exe)$" } })

-- Gamestore tags
hl.window_rule({ name = "tag-game-store", tag = "+gamestore",
    match = { class = "^([Ss]team)$" } })
hl.window_rule({ name = "tag-game-store-2", tag = "+gamestore",
    match = { title = "^([Ll]utris)$" } })
hl.window_rule({ name = "tag-game-store-3", tag = "+gamestore",
    match = { class = "^(com.heroicgameslauncher.hgl)$" } })

-- File manager tags
hl.window_rule({ name = "tag-file-manager", tag = "+file-manager",
    match = { class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" } })
hl.window_rule({ name = "tag-file-manager-2", tag = "+file-manager",
    match = { class = "^(app.drey.Warp)$" } })

-- Terminal tags
hl.window_rule({ name = "tag-terminal", tag = "+terminal",
    match = { class = "^(Alacritty|kitty|kitty-dropterm|Ghostty)$" } })

-- Email tags
hl.window_rule({ name = "tag-email-client", tag = "+email",
    match = { class = "^([Tt]hunderbird|org.gnome.Evolution)$" } })
hl.window_rule({ name = "tag-email-client-2", tag = "+email",
    match = { class = "^(eu.betterbird.Betterbird)$" } })

-- Project/IDE tags
hl.window_rule({ name = "tag-ides", tag = "+projects",
    match = { class = "^(codium|codium-url-handler|VSCodium)$" } })
hl.window_rule({ name = "tag-ides-2", tag = "+projects",
    match = { class = "^(VSCode|code-url-handler)$" } })
hl.window_rule({ name = "tag-ides-3", tag = "+projects",
    match = { class = "^(jetbrains-.+)$" } }) -- JetBrains IDEs

-- Settings tags
hl.window_rule({ name = "tag-settings", tag = "+settings",
    match = { title = "^(ROG Control)$" } })
hl.window_rule({ name = "tag-settings-2", tag = "+settings",
    match = { class = "^(wihotspot(-gui)?)$" } })
hl.window_rule({ name = "tag-settings-3", tag = "+settings",
    match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" } })
hl.window_rule({ name = "tag-settings-4", tag = "+settings",
    match = { class = "^(gnome-disks|wihotspot(-gui)?)$" } })
hl.window_rule({ name = "tag-settings-5", tag = "+settings",
    match = { title = "(Kvantum Manager)" } })
hl.window_rule({ name = "tag-settings-6", tag = "+settings",
    match = { class = "^(file-roller|org.gnome.FileRoller)$" } })
hl.window_rule({ name = "tag-settings-7", tag = "+settings",
    match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" } })
hl.window_rule({ name = "tag-settings-8", tag = "+settings",
    match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" } })
hl.window_rule({ name = "tag-settings-9", tag = "+settings",
    match = { class = "^(qt5ct|qt6ct|[Yy]ad)$" } })
hl.window_rule({ name = "tag-settings-10", tag = "+settings",
    match = { class = "(xdg-desktop-portal-gtk)" } })
hl.window_rule({ name = "tag-settings-11", tag = "+settings",
    match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" } })
hl.window_rule({ name = "tag-settings-12", tag = "+settings",
    match = { class = "^([Rr]ofi)$" } })

-- Viewer tags
hl.window_rule({ name = "tag-viewer", tag = "+viewer",
    match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" } })
hl.window_rule({ name = "tag-viewer-2", tag = "+viewer",
    match = { class = "^(evince)$" } })
hl.window_rule({ name = "tag-viewer-3", tag = "+viewer",
    match = { class = "^(eog|org.gnome.Loupe)$" } })

------------------------------
---- SPECIAL OVERRIDES -------
------------------------------

-- Disable blur and force full opacity for multimedia video
hl.window_rule({
    name     = "special-override-for-multimedia",
    no_blur  = true,
    opacity  = 1.0,
    match    = { tag = "multimedia_video*" },
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

hl.window_rule({ name = "workspace-gamestore",
    workspace = "1 silent",
    match     = { tag = "gamestore*" } })

hl.window_rule({ name = "workspace-messaging",
    workspace = "9 silent",
    opacity   = 0.94,
    match     = { tag = "im*" } })

hl.window_rule({ name = "workspace-games",
    workspace  = "1",
    no_blur    = true,
    fullscreen = true,
    match      = { tag = "games*" } })

hl.window_rule({ name = "workspace-multimedia",
    workspace = "9 silent",
    opacity   = 0.94,
    match     = { tag = "multimedia*" } })

--------------------
---- FLOAT DIALOGS --
--------------------

hl.window_rule({ name = "dialogs",
    float  = true,
    center = true,
    match  = { title = "^(Authentication Required)$" } })

hl.window_rule({ name = "dialogs-vs-code",
    float = true,
    match = { class = "(codium|codium-url-handler|VSCodium)",
              title = "negative:(.*codium.*|.*VSCodium.*)" } })

hl.window_rule({ name = "dialogs-3",
    float = true,
    match = { class = "^(com.heroicgameslauncher.hgl)$",
              title = "negative:(Heroic Games Launcher)" } })

hl.window_rule({ name = "dialogs-steam",
    float = true,
    match = { class = "^([Ss]team)$",
              title = "negative:^([Ss]team)$" } })

hl.window_rule({ name = "dialogs-thunar",
    float = true,
    match = { class = "([Tt]hunar)",
              title = "negative:(.*[Tt]hunar.*)" } })

hl.window_rule({ name = "dialogs-4",
    float  = true,
    size   = "(monitor_w*0.7) (monitor_h*0.6)",
    center = true,
    match  = { title = "^(Add Folder to Workspace)$" } })

hl.window_rule({ name = "dialog-save-as",
    float  = true,
    size   = "(monitor_w*0.7) (monitor_h*0.6)",
    center = true,
    match  = { title = "^(Save As)$" } })

hl.window_rule({ name = "dialog-open-files",
    float = true,
    size  = "(monitor_w*0.7) (monitor_h*0.6)",
    match = { initial_title = "(Open Files)" } })

-----------------
---- OPACITY ----
-----------------

hl.window_rule({ name = "blur-browser",       opacity = 0.96, match = { tag = "browser*" } })
hl.window_rule({ name = "blur-ides",          opacity = 0.98, match = { tag = "projects*" } })
hl.window_rule({ name = "blur-file-managers", opacity = 0.9,  match = { tag = "file-manager*" } })
hl.window_rule({ name = "blur-terminal",      opacity = 0.8,  match = { tag = "terminal*" } })
hl.window_rule({ name = "blur-setting",       opacity = 0.8,  match = { tag = "settings*" } })
hl.window_rule({ name = "blur-viewer",        opacity = 0.82, match = { tag = "viewer*" } })
hl.window_rule({ name = "blur-wallpaper",     opacity = 0.9,  match = { tag = "wallpaper*" } })

hl.window_rule({ name = "blur-text-editor",
    opacity = 0.8,
    match   = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" } })

hl.window_rule({ name = "blur-deluge",
    opacity = 0.9,
    match   = { class = "^(deluge)$" } })

hl.window_rule({ name = "blur-seahorse",
    opacity = 0.9,
    match   = { class = "^(seahorse)$" } })

hl.window_rule({ name = "special-blur-vs-code",
    opacity = 0.97,
    match   = { class = "^(code)$" } })

---------------------------
---- PICTURE-IN-PICTURE ----
---------------------------

hl.window_rule({
    name             = "rule-for-pip",
    opaque           = true,
    workspace        = "9 silent",
    keep_aspect_ratio = true,
    size             = "1219 686",
    float            = true,
    pin              = true,
    move             = "((monitor_w*0.51)) (-(monitor_h*0.65))",
    match            = { title = "^(Picture-in-Picture)$" },
})

--------------------------
---- JETBRAINS FOCUS -----
--------------------------

-- Avoid stealing focus for IntelliJ Products' popup windows
hl.window_rule({ name = "windowrule-67",
    no_initial_focus = true,
    match = { class = "^(jetbrains-*)" } })

hl.window_rule({ name = "windowrule-68",
    no_initial_focus = true,
    match = { title = "^(wind.*)$" } })

----------------------------
---- APP WORKSPACE RULES ----
----------------------------

-- Zapzap (WhatsApp) → workspace 9
hl.window_rule({ name = "windowrule-69",
    workspace = "9 silent",
    match     = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" } })

-- Youtube Music → workspace 9
hl.window_rule({ name = "windowrule-70",
    workspace = "9 silent",
    match     = { class = "^(com.github.th_ch.youtube_music)$" } })

-- Discord → workspace 9
hl.window_rule({ name = "windowrule-71",
    workspace = "9 silent",
    match     = { class = "^([Dd]iscord)$" } })

-- Spotify → workspace 9
hl.window_rule({ name = "windowrule-72",
    workspace = "9 silent",
    match     = { class = "^([Ss]potify)$" } })

-- Thunderbird → workspace 9
hl.window_rule({ name = "windowrule-73",
    workspace = "9 silent",
    match     = { class = "^([Tt]hunderbird)$" } })

-- Zen Browser → workspace 2, maximized
hl.window_rule({ name = "windowrule-74",
    workspace = "2",
    maximize  = true,
    match     = { class = "^(zen-alpha|zen)$" } })

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
    name      = "windowrule-2",
    no_focus  = true,
    match     = {
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
