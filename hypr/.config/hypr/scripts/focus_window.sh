#!/bin/bash

# $1: direction (l, r, u, d)
DIR=$1

# Fetch the current active layout
LAYOUT=$(hyprctl getoption general:layout -j | jq -r '.str')

if [ "$LAYOUT" == "dwindle" ]; then
    # Standard dwindle focus movement
    hyprctl dispatch movefocus "$DIR"
else
    # Layout-specific focus (scrolling/master)
    hyprctl dispatch layoutmsg focus "$DIR"
fi