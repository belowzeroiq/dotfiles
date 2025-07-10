#!/bin/bash

# Hyprland Performance Optimization Script
# Run this after starting Hyprland

# Set CPU governor to performance
echo "Setting CPU governor to performance..."
sudo cpupower frequency-set -g performance 2>/dev/null || echo "cpupower not available"

# Disable composition for gaming
alias game-mode='hyprctl keyword decoration:blur:enabled false && hyprctl keyword decoration:drop_shadow false && hyprctl keyword decoration:rounding 0'
alias normal-mode='hyprctl keyword decoration:blur:enabled true && hyprctl keyword decoration:drop_shadow true && hyprctl keyword decoration:rounding 12'

# Set high priority for compositor
if pgrep -x "Hyprland" > /dev/null; then
    sudo renice -10 $(pgrep -x "Hyprland") 2>/dev/null || echo "Could not set Hyprland priority"
fi

# Optimize system parameters
echo "Optimizing system parameters..."
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-hyprland.conf > /dev/null
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.d/99-hyprland.conf > /dev/null

# Apply sysctl settings
sudo sysctl -p /etc/sysctl.d/99-hyprland.conf 2>/dev/null || echo "Could not apply sysctl settings"

echo "Performance optimizations applied!"
