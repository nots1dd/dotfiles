#!/bin/bash

selected=$(echo "wal3.png
wal5.png
wal12.png
wal13.png
wal14.png
wal15.png
wal16.png
wal17.png
wal18.png
wal19.png
wal20.png
wal21.png
wal22.png
wal23.png
wal24.png
wal25.png
wal26.png
wal27.png
wal28.png
wal29.png
wal30.png
wal30.gif
wal31.png
wal32.png
walgood.png" | rofi -dmenu -theme "/home/s1dd/Downloads/rofi/files/launchers/type-3/style-10.rasi")
echo "$selected"

if [[ "$selected" == *"gif" ]]; then
  # Set hyprlock.conf for GIF wallpaper
  sed -i "s|path=.*|path=/home/s1dd/wallpapers/wal3.png|" /home/s1dd/.config/hypr/hyprlock.conf
  swww img "/home/s1dd/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
else
  # Set hyprlock.conf for non-GIF wallpaper
  sed -i "s|path=.*|path=/home/s1dd/wallpapers/$selected|" /home/s1dd/.config/hypr/hyprlock.conf
  swww img "/home/s1dd/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
fi
