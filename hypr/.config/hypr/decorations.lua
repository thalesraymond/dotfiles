-- decorations.lua
-- Appearance / look-and-feel configuration
-- https://wiki.hypr.land/Configuring/Basics/Variables/
--
-- Colors are sourced from the matugen-generated colors.lua file.
-- Run matugen to regenerate colors.lua from your wallpaper.

require("colors")

hl.config({
    general = {
        border_size      = 2,
        gaps_in          = 5,
        gaps_out         = 10,

        col              = {
            -- Active and inactive borders using matugen palette
            active_border   = { colors = { colors.primary, colors.secondary, colors.tertiary }, angle = 45 },
            inactive_border = { colors = { colors.primary_container, colors.secondary_container, colors.tertiary_container }, angle = 45 },
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before turning this on
        allow_tearing    = false,

        layout           = "scrolling",
    },

    decoration = {
        rounding           = 10,
        rounding_power     = 2,

        active_opacity     = 0.95,
        inactive_opacity   = 0.8,
        fullscreen_opacity = 1.0,

        dim_inactive       = true,
        dim_strength       = 0.1,
        dim_special        = 0.8,

        shadow             = {
            enabled        = false,
            range          = 1,
            render_power   = 2,

            color          = colors.primary_container,
            color_inactive = colors.surface_variant,
        },

        blur               = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            ignore_opacity    = true,
            new_optimizations = true,
            special           = true,
            popups            = true,
        },
    },

    group = {
        col = {
            border_active = colors.secondary_container,
        },

        groupbar = {
            col = {
                active = colors.surface_container_highest,
            },
        },
    },

    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },

    scrolling = {
        fullscreen_on_one_column = true,
    },

    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },

    input = {
        kb_layout    = "us",
        kb_variant   = "intl",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = -0.4, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll = false,
        },
    },
})

-- 3-finger horizontal swipe to switch workspaces
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "G305",
    sensitivity = -0.5,
})
