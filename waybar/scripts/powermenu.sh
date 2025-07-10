#!/bin/bash

# Power menu options
options="🔒 Lock\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown\n💤 Sleep"

# Show wofi menu and get selection
selected=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 300 --height 250 --style ~/.config/wofi/powermenu.css)

# Execute based on selection
case $selected in
    "🔒 Lock")
        hyprlock
        ;;
    "🚪 Logout")
        hyprctl dispatch exit
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "💤 Sleep")
        systemctl suspend
        ;;
esac
