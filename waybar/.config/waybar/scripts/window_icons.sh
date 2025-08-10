#!/usr/bin/env bash

# Current workspace ID
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Get window classes for current workspace
WINDOWS=$(hyprctl clients -j | jq -r \
    --argjson ws "$CURRENT_WS" \
    '.[] | select(.workspace.id == $ws) | .class')

# Nerd Font icon mapping for your apps
declare -A ICONS=(
    ["zen"]="󰈹"                    # Zen Browser
    ["zen-browser"]="󰈹"
    ["zapzap"]=""                  # ZapZap
    ["firefox"]=""                  # Firefox
    ["qutebrowser"]=""             # Qutebrowser
    ["vivaldi-stable"]=""          # Vivaldi
    ["thunderbird"]="󰇮"             # Thunderbird
    ["discord"]="󰙴"                 # Discord
    ["spotify"]="󰓇"                 # Spotify
    ["steam"]="󰓓"                   # Steam
    ["lutris"]="󰺵"                  # Lutris
    ["ghostty"]="󰆍"                  # Ghostty Terminal
    ["foot"]="󰆍"                     # Foot Terminal (fallback)
    ["picture-in-picture"]="󰕱"     # Zen PiP window
    ["webstorm"]="󰛦"                 # Webstorm
    ["unityhub"]="󱂬"                 # Unity Hub
    ["rider"]="󰛲"                    # Rider
    ["default"]=""                  # Default icon
)

ICON_STRING=""

while read -r class; do
    # Normalize to lowercase
    app=$(echo "$class" | tr '[:upper:]' '[:lower:]')

    # Match icon
    icon="${ICONS[$app]:-${ICONS["default"]}}"

    ICON_STRING+="$icon "
done <<< "$WINDOWS"

# Output JSON for Waybar
echo "{\"text\": \"${ICON_STRING}\"}"
