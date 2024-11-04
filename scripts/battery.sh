#!/bin/bash

# Check if battery directory exists
BATTERY_PATH="/sys/class/power_supply/BAT0"

if [ -d "$BATTERY_PATH" ]; then
    # Get the battery percentage
    BATTERY_CAPACITY=$(cat "$BATTERY_PATH/capacity")
    
    if [ "$BATTERY_CAPACITY" -lt 10 ]; then
        # Display battery percentage in red if below 10%
        echo "<span foreground=\"red\">Bat.$BATTERY_CAPACITY%</span>"
    else
        echo "<span>Bat.$BATTERY_CAPACITY%</span>"
    fi
else
    echo "No battery."
fi

