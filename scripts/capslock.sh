#!/bin/bash

# Directory containing the Caps Lock brightness file
brightness_file="/sys/class/leds/input6::capslock/brightness"
theme="~/dotfiles/rofi/wals/wal-config.rasi"

# Function to display Rofi message
show_message() {
    rofi -e "$1" -theme "$theme" &
    rofi_pid=$!
    sleep 1
    kill "$rofi_pid"
}

# Function to monitor Caps Lock status
monitor_caps_lock() {
    # Initialize variable to store previous status
    previous_status=$(cat "$brightness_file")

    # Continuously monitor Caps Lock status
    while true; do
        # Read current status from the brightness file
        read -r current_status < "$brightness_file"

        # Check if Caps Lock status has changed
        if [ "$current_status" != "$previous_status" ]; then
            # Caps Lock status has changed
            if [ "$current_status" -eq 1 ]; then
                # Caps Lock turned ON
                show_message "Caps Lock is turned ON!"
            else
                # Caps Lock turned OFF
                show_message "Caps Lock is turned OFF!"
            fi
            # Update previous_status
            previous_status=$current_status
        fi

        # Sleep to avoid CPU usage
        sleep 0.1
    done
}

monitor_caps_lock
