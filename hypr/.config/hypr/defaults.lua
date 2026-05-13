-- defaults.lua
-- Environment variables and base settings
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

------------------------------
---- ENVIRONMENT VARIABLES ----
------------------------------

-- Editor
hl.env("EDITOR", "nvim")

-- Toolkit backend
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- QT variables
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- hyprland-qt-support
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")

-- XWayland apps scale fix
hl.env("GDK_SCALE", "1")
hl.env("QT_SCALE_FACTOR", "1")

-- Cursor (Bibata-Modern-Ice)
-- NOTE: You must have the hyprcursor version installed.
-- https://wiki.hyprland.org/Hypr-Ecosystem/hyprcursor/
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")

-- Firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Electron >28 apps
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- NVIDIA
-- See https://wiki.hyprland.org/Nvidia/#environment-variables
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("GSK_RENDERER", "ngl")
