-- Hyprland Lua configuration
-- https://wiki.hypr.land/Configuring/Start/

-- Each require() is a separate lua scope, so errors in one file
-- don't stop execution of others.

require("defaults")
require("monitors")
require("workspaces")
require("animations")
require("decorations")
require("keybindings")
require("windowRules")
require("startupApps")
