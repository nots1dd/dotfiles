#!/bin/bash

theme="~/dotfiles/rofi/wals/wal-config.rasi"

show_message() {
    rofi -e "$1" -theme "$theme" &
    rofi_pid=$!
    sleep 1
    kill "$rofi_pid"
}

selected=$(echo "wal3.png
wal5.png
wal11.png
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
wal33.png
wal34.png
wal35.png
wal36.png
wal37.png
wal38.png
wal39.png
walgood.png" | rofi -dmenu -theme "$theme")
echo "$selected"

if [ -z "$selected" ]; then
    show_message "No wallpaper selected. Exiting without making any changes."
    exit 1
fi

if [[ "$selected" == *"gif" ]]; then
  # Set hyprlock.conf for GIF wallpaper
  sed -i "s|path=.*|path=/home/s1dd/wallpapers/wal3.png|" /home/s1dd/.config/hypr/hyprlock.conf
  swww img "/home/s1dd/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
  show_message "Success :: wallpaper changed to $selected : Hyprlock wal set to wal3.png" -theme "$theme"
else
  # Set hyprlock.conf for non-GIF wallpaper
  sed -i "s|path=.*|path=/home/s1dd/wallpapers/$selected|" /home/s1dd/.config/hypr/hyprlock.conf
  swww img "/home/s1dd/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
  show_message "Success :: wallpaper changed to $selected!" -theme "$theme"
fi
