#!/bin/bash

while true; do
    # Work for 30 minutes
    sleep 1800  # 1800 seconds = 30 minutes
    # Send persistent notification to take a break
    notify-send -u critical -t 0 "Take a break!" "Time to rest for 10 minutes."
    # Play a beep sound
    beep

    # Break for 10 minutes
    sleep 600  # 600 seconds = 10 minutes
    # Send persistent notification to resume work
    notify-send -u critical -t 0 "Back to work!" "Time to resume your tasks."
    # Play a beep sound
    beep
done

