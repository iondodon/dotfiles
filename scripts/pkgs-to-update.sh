#!/bin/bash

# Get the number of packages that can be upgraded
num_updates=$(aptitude search '~U' | wc -l)

echo "⇑$num_updates"

