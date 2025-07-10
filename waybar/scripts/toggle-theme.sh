#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
DARK="$WAYBAR_DIR/config-dark"
LIGHT="$WAYBAR_DIR/config-light"
ACTIVE="$WAYBAR_DIR/config"

# Determine current style
CURRENT_STYLE=$(grep style "$ACTIVE" | grep -o 'style-[a-z]*\.css')

if [[ "$CURRENT_STYLE" == "style-light.css" ]]; then
    cp "$DARK" "$ACTIVE"
else
    cp "$LIGHT" "$ACTIVE"
fi

# Restart Waybar
pkill waybar
sleep 0.3
waybar &
