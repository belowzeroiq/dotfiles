#!/bin/bash

# Options
options="🔒 Lock\n🚪 Logout\n💤 Suspend\n🔁 Reboot\n⏻ Shutdown"

# Run rofi with better spacing - using window mode instead of dmenu
chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -theme synth-clean \
    -lines 5 \
    -columns 1 \
    -width 25 \
    -location 0 \
    -yoffset 0 \
    -xoffset 0 \
    -fixed-num-lines \
    -no-custom \
    -font "mono 12")

# Act on choice
case "$chosen" in
    "🔒 Lock")
        hyprctl dispatch dpms off && hyprlock
        ;;
    "🚪 Logout")
        hyprctl dispatch exit
        ;;
    "💤 Suspend")
        hyprlock && systemctl suspend
        ;;
    "🔁 Reboot")
        systemctl reboot
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
esac
