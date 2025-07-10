#!/bin/bash

if rfkill list bluetooth | grep -q "yes"; then
    echo "󰂲"  # Bluetooth off
else
    echo "󰂯"  # Bluetooth on
fi
