#!/bin/bash

# Interval in seconds between each beep
INTERVAL=900 # 15 minutes

# Infinite loop to beep at each interval until stopped manually
while true
do
    paplay /usr/share/sounds/freedesktop/stereo/bell.oga
    sleep $INTERVAL
done

