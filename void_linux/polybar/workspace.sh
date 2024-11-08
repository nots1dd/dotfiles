#!/bin/bash

# Get the active workspace number and total number of workspaces
active_workspace=$(wmctrl -d | grep '*' | cut -d ' ' -f1)
workspace_names=$(wmctrl -d | awk '{print $1 ": " $NF}')

# Display the current workspace name or number
echo "$workspace_names" | grep "^$active_workspace:" | cut -d ' ' -f2-

# Handle click events for switching workspaces
if [[ $1 == "--next" ]]; then
    wmctrl -s $(( (active_workspace + 1) % $(wmctrl -d | wc -l) ))
elif [[ $1 == "--prev" ]]; then
    total_workspaces=$(wmctrl -d | wc -l)
    wmctrl -s $(( (active_workspace - 1 + total_workspaces) % total_workspaces ))
fi
