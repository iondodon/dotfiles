#!/bin/bash

# Update the package list, ignoring all output
# sudo apt update > /dev/null 2>&1

# Get the number of upgradable packages
upgradable_count=$(apt list --upgradable 2>/dev/null | grep -v "^Listing" | wc -l)

# Check if the number of updates is greater than 0
if [ "$upgradable_count" -gt 0 ]; then
    # If there are updates, make the arrow green
    echo "<span foreground=\"green\" font_size=\"10.0pt\">⇑</span>$upgradable_count"
else
    # If no updates, make the arrow a neutral color (e.g., gray or keep it unchanged)
    echo "<span font_size=\"10.0pt\">⇑</span>$upgradable_count"
fi

