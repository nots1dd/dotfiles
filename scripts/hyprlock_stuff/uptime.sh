#!/bin/bash

# Get the number of active workspaces in Hyprland
uptime_info=$(uptime -p | sed 's/up //')

# Display the uptime info, Wi-Fi icon, and active workspaces
echo "$uptime_info"
