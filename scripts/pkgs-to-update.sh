#!/bin/bash

# Get the number of packages that can be upgraded
num_updates=$(aptitude search '~U' | wc -l)

# Check if the number of updates is greater than 0
if [ "$num_updates" -gt 0 ]; then
    # If there are updates, make the arrow green
     echo "<span foreground=\"green\" font_size=\"11.0pt\">⇑</span>$num_updates"
else
    # If no updates, make the arrow a neutral color (e.g., gray or keep it unchanged)
    echo "<span font_size=\"11.0pt\">⇑</span>$num_updates"
fi

