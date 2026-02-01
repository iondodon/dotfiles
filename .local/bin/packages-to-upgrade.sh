#!/bin/bash

# Print the number of available package upgrades (Arch only now).

arrow_default='⇑'
arrow_green='<span foreground="green">⇑</span>'

updates="?"

if ! command -v pacman >/dev/null 2>&1; then
  echo "${arrow_default}Not Arch."
  exit 0
fi

if ! command -v checkupdates >/dev/null 2>&1; then
  echo "${arrow_default}checkupdates missing"
  exit 0
fi

if ! command -v yay >/dev/null 2>&1; then
  echo "${arrow_default}yay missing"
  exit 0
fi

repo_updates="0"
aur_updates="0"

check_output="$(checkupdates 2>/dev/null)"
check_status=$?
if [ "$check_status" -eq 0 ]; then
  repo_updates="$(printf '%s\n' "$check_output" | wc -l)"
elif [ "$check_status" -eq 2 ]; then
  repo_updates="0"
else
  echo "${arrow_default}checkupdates"
  exit 0
fi

# -Qua is used to count the AUR packages only
# because yay can also count the official repos  
aur_output="$(yay -Qua --noprogressbar 2>/dev/null)"
aur_status=$?
if [ "$aur_status" -eq 0 ]; then
  aur_updates="$(printf '%s\n' "$aur_output" | wc -l)"
elif [ "$aur_status" -eq 1 ]; then
  aur_updates="0"
else
  echo "${arrow_default}yay"
  exit 0
fi

updates="$((repo_updates + aur_updates))"

if [[ "$updates" =~ ^[0-9]+$ ]] && [ "$updates" -gt 0 ]; then
  echo "${arrow_green}${updates}"
elif [[ "$updates" =~ ^[0-9]+$ ]]; then
  echo "${arrow_default}${updates}"
fi
