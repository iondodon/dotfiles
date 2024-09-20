#!/bin/bash

# Check if an OpenVPN client is active by looking for the specific OpenVPN command
if pgrep -f "openvpn --config" > /dev/null; then
  echo "🟢 VPN"
else
  echo "🔴 VPN"
fi

