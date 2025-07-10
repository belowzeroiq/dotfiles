#!/bin/bash

# Hyprland Aliases and Functions

# Screenshot functions
alias ss-full='hyprshot -m output'
alias ss-window='hyprshot -m window'
alias ss-region='hyprshot -m region'

# Quick config edits
alias edit-hypr='$EDITOR ~/.config/hypr/hyprland.conf'
alias edit-waybar='$EDITOR ~/.config/waybar/config'
alias edit-wofi='$EDITOR ~/.config/wofi/config'

# Performance modes
alias game-mode='hyprctl keyword decoration:blur:enabled false && hyprctl keyword decoration:drop_shadow false && hyprctl keyword decoration:rounding 0 && notify-send "Game Mode" "Effects disabled for performance"'
alias normal-mode='hyprctl keyword decoration:blur:enabled true && hyprctl keyword decoration:drop_shadow true && hyprctl keyword decoration:rounding 12 && notify-send "Normal Mode" "Effects re-enabled"'

# System info
alias hypr-info='hyprctl systeminfo'
alias hypr-clients='hyprctl clients'
alias hypr-workspaces='hyprctl workspaces'

# Clipboard management
alias clip-history='cliphist list | wofi --dmenu | cliphist decode | wl-copy'
alias clip-clear='cliphist wipe'

# Wallpaper functions
wallpaper() {
    if [ -f "$1" ]; then
        swww img "$1" --transition-type wipe --transition-duration 2
        cp "$1" ~/Pictures/wallpaper.jpg
        notify-send "Wallpaper" "Changed to $(basename "$1")"
    else
        echo "File not found: $1"
    fi
}

# Hyprland reload
alias hypr-reload='hyprctl reload'

# Quick app launchers
alias files='thunar'
alias term='kitty'
alias browser='firefox'

echo "Hyprland aliases loaded!"
