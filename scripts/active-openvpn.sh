#!/bin/bash

# Check if an OpenVPN client is active by looking for the specific OpenVPN command
if pgrep -f "openvpn --config" > /dev/null; then
  echo "<span foreground=\"green\" font_size=\"large\">◉︎</span>VPN"
else
  echo "<span font_size=\"large\">◉︎</span>VPN"
fi

