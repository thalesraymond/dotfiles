#!/bin/bash

# $1 is the direction (l, r, u, d)
DIRECTION=$1

# Get the current layout name from hyprctl
LAYOUT=$(hyprctl getoption general:layout -j | jq -r '.str')

if [ "$LAYOUT" == "dwindle" ]; then
    hyprctl dispatch movewindow "$DIRECTION"
else
    # Assuming hyprscrolling/master logic
    hyprctl dispatch layoutmsg movewindowto "$DIRECTION"
fi