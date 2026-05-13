-- startupApps.lua
-- Autostart applications and exec-once commands
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local polkit_agents = {
    "/usr/libexec/hyprpolkitagent",
    "/usr/lib/hyprpolkitagent",
    "/usr/lib/polkit-kde-authentication-agent-1",
    "/usr/libexec/polkit-mate-authentication-agent-1",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
    "/usr/lib/hyprpolkitagent/hyprpolkitagent",
    "/usr/lib/polkit-gnome-authentication-agent-1",
    "/usr/libexec/polkit-gnome-authentication-agent-1",
    "/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1",
    "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1"
}

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
    -- Polkit agent (start first one found)
    for _, agent in ipairs(polkit_agents) do
        local f = io.open(agent, "r")
        if f then
            f:close()
            hl.exec_cmd(agent .. " &")
            break
        end
    end

    for _, app in ipairs(startup_apps) do
        hl.exec_cmd(app)
    end
end)
