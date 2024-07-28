#!/bin/bash

show_msg() {
    rofi -e "$1" -theme "~/dotfiles/rofi/wals/wal-config.rasi"
}


# Check if the process "ags" is running
if pgrep -x "ags" > /dev/null
then
    # If it's running, kill it
    show_msg "AGS LAUNCHER :: ags process found. Esc to Quit ags" && ags -q
    
    # Sleep for 1 second
    sleep 1
fi

# Relaunch ags
show_msg "AGS LAUNCHER :: Press Esc to relaunch ags"
ags
