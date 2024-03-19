#!/bin/bash
#
selected=$(echo "wal15.png
wal14.png
wal13.png
wal17.jpg
wal5.png
walgood.png
wal18.png
wal3.png" | rofi -dmenu -theme "/home/s1dd/rofi/files/launchers/type-3/style-9.rasi")
echo "$selected"
swww img "/home/s1dd/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
killall -SIGUSR2 waybar

sed -i "s|path=.*|path=/home/s1dd/wallpapers/$selected|" /home/s1dd/.config/hypr/hyprlock.conf # changes lockscreen wallpaper (jpg imgs will give only a blank screen)
sed -i "s|background-image:.*|background-image: url(\"/home/s1dd/wallpapers/$selected\", width);|" /home/s1dd/dotfiles/scripts/rofi/nova-dark.rasi


