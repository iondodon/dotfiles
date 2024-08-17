#!/bin/bash

# Get the number of packages that can be upgraded
num_updates=$(aptitude search '~U' | wc -l)

# Output the number of packages with an up arrow
echo "⇑$num_updates"
