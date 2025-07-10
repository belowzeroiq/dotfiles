#!/bin/bash

# Options
options="🔒 Lock\n🚪 Logout\n💤 Suspend\n🔁 Reboot\n⏻ Shutdown"

# Run rofi in custom mode (not dmenu)
chosen=$(echo -e "$options" | rofi -show power -modi "power:echo -e '$options'" -theme synth-clean)

# Act on choice
case "$chosen" in
    "🔒 Lock") hyprctl dispatch dpms off && swaylock ;;
    "🚪 Logout") hyprctl dispatch exit ;;
    "💤 Suspend") systemctl suspend ;;
    "🔁 Reboot") systemctl reboot ;;
    "⏻ Shutdown") systemctl poweroff ;;
esac
