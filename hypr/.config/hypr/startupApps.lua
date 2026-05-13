-- startupApps.lua
-- Autostart applications and exec-once commands
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Theme
    hl.exec_cmd("xsettingsd")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme ''")

    -- Cursor
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

    -- Dbus / systemd environment
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Polkit agent
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/Polkit.sh &")

    -- DMS (shell / bar)
    hl.exec_cmd("sleep 3 && dms run &")

    -- Hyprland plugins
    hl.exec_cmd("hyprpm reload") -- Ensure plugins are loaded

    -- Apps
    hl.exec_cmd("sleep 3 & openrgb --startminimized &")
    hl.exec_cmd("solaar -w hide &")
    hl.exec_cmd("zapzap &")
    hl.exec_cmd("sleep 3 && spotify")
    -- hl.exec_cmd("discord --start-minimized &")
    hl.exec_cmd("zen-browser &")
    hl.exec_cmd("lutris &")
    hl.exec_cmd("steam &")
end)
