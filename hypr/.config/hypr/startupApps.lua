-- startupApps.lua
-- Autostart applications and exec-once commands
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local startup_apps = {
    -- Theme
    "xsettingsd",
    "gsettings set org.gnome.desktop.interface color-scheme prefer-dark",
    "gsettings set org.gnome.desktop.interface gtk-theme ''",

    -- Cursor
    "gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice",
    "gsettings set org.gnome.desktop.interface cursor-size 24",
    "hyprctl setcursor Bibata-Modern-Ice 24",

    -- Dbus / systemd environment
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",

    -- Polkit agent
    os.getenv("HOME") .. "/.config/hypr/scripts/Polkit.sh &",

    -- DMS (shell / bar)
    "sleep 3 && dms run &",

    -- Hyprland plugins
    "hyprpm reload", -- Ensure plugins are loaded

    -- Apps
    "sleep 3 & openrgb --startminimized &",
    "solaar -w hide &",
    "zapzap &",
    "sleep 3 && spotify",
    -- "discord --start-minimized &",
    "zen-browser &",
    "lutris &",
    "steam &",
}

hl.on("hyprland.start", function()
    for _, app in ipairs(startup_apps) do
        hl.exec_cmd(app)
    end
end)
