#!/bin/bash

# Time in milliseconds (300000 ms = 5 minutes)
IDLE_TIME_LIMIT=300000  #300000

# Time interval to reset idle status (4 minutes, or 240000 milliseconds)
RESET_INTERVAL=240000  #240000

# Get screen dimensions
SCREEN_WIDTH=$(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d 'x' -f 1)
SCREEN_HEIGHT=$(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d 'x' -f 2)

# Calculate center position
CENTER_X=$((SCREEN_WIDTH / 2))
CENTER_Y=$((SCREEN_HEIGHT / 2))

while true; do
  # Get the idle time in milliseconds
  IDLE_TIME=$(xprintidle)

  if [ "$IDLE_TIME" -gt "$IDLE_TIME_LIMIT" ]; then
    echo "move"
    # Move the mouse to the center of the screen
    xdotool mousemove $CENTER_X $CENTER_Y

    # Move the mouse to the top-left corner (0,0)
    xdotool mousemove 0 0

    # Move the mouse back to the center
    xdotool mousemove $CENTER_X $CENTER_Y
  fi

  # Sleep for RESET_INTERVAL before checking again
  sleep $(($RESET_INTERVAL / 1000))
done

