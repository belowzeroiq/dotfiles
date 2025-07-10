#!/bin/bash

# Check if gammastep is running
if pgrep -x "gammastep" >/dev/null; then
    pkill gammastep
    notify-send "Night Light" "Disabled" -i weather-clear-night
else
    # Start gammastep with your preferred settings
    gammastep -O 4600 &  # 3500K temperature - adjust as needed
    notify-send "Night Light" "Enabled" -i weather-clear-night
fi

# Refresh Waybar
pkill -RTMIN+9 waybar
