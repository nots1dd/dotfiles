#!/bin/bash
my_array=(/home/s1dd/wallpapers/*)
image=${my_array[ $RANDOM % ${#my_array[@]} ]}
swww img ${image} --transition-type random --transition-step 1 --transition-duration 2
#wal -i ${image}
#rm ~/.config/vesktop/themes/pywal-discord-modified.theme.css
#pywal-discord -p ~/.config/vesktop/themes/ -t modified
killall -SIGUSR2 waybar
#~/.cache/wal/colors-keyboardcolors.sh
