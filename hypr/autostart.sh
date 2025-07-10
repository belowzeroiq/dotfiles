#!/bin/bash

# Hyprland Autostart Script

# Wait a bit for Hyprland to fully load
sleep 2

# Apply performance optimizations
~/.config/hypr/performance.sh &

# Set wallpaper
swww img ~/Pictures/wallpaper.jpg --transition-type wipe --transition-duration 2 &

# Start clipboard manager
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

echo "Hyprland autostart complete!"
