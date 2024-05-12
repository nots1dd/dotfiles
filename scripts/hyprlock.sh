#!/bin/bash

# Function to update the label in the .conf file
update_label() {
    local status=$(cat /sys/class/power_supply/BAT1/status)
    local cap=$(cat /sys/class/power_supply/BAT1/capacity)
    
    if [ "$status" = "Charging" ]; then
        # Use sed to update the label in the .conf file
        sed -i "s|<span size='20pt' foreground='##006D5B'>󰁾 </span>|<span size='20pt' foreground='##006D5B'>🗲 </span>|g" /home/s1dd/.config/hypr/hyprlock.conf
    elif [ "$status" = "Full" ]; then
        # Battery is full, add full battery icon (to either case)
        sed -i "s|<span size='20pt' foreground='##006D5B'>🗲 </span>|<span size='20pt' foreground='##006D5B'>󰁹 </span>|g" /home/s1dd/.config/hypr/hyprlock.conf
        sed -i "s|<span size='20pt' foreground='##006D5B'>󰁾 </span>|<span size='20pt' foreground='##006D5B'>󰁹 </span>|g" /home/s1dd/.config/hypr/hyprlock.conf
    elif [ "$status" = "Discharging" ] && [ "$cap" -lt 100 ]; then
        # Battery is discharging and not full, use another icon
        sed -i "s|<span size='20pt' foreground='##006D5B'>🗲 </span>|<span size='20pt' foreground='##006D5B'>󰁾 </span>|g" /home/s1dd/.config/hypr/hyprlock.conf
        # Battery is full and discharging, use another icon
        sed -i "s|<span size='20pt' foreground='##006D5B'>󰁹 </span>|<span size='20pt' foreground='##006D5B'>󰁾 </span>|g" /home/s1dd/.config/hypr/hyprlock.conf
    fi

    hyprlock
}

# Update only the battery Unicode in the label when charging
update_label
