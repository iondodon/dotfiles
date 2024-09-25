#!/bin/bash

# Interval in seconds between each beep
INTERVAL=5

# Infinite loop to beep at each interval until stopped manually
while true
do
    paplay /usr/share/sounds/freedesktop/stereo/bell.oga
    sleep $INTERVAL
done

