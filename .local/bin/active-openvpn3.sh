#!/bin/bash

# Check if an OpenVPN client session is active
if openvpn3 sessions-list | grep -q "Path:"; then
  echo "<span foreground=\"green\" font_size=\"large\">◉︎</span>VPN"
else
  echo "<span font_size=\"large\">◉︎</span>VPN"
fi
