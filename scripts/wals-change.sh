#!/bin/bash

theme="~/dotfiles/rofi/wals/wal-config.rasi"

show_message() {
    rofi -e "$1" -theme "$theme" &
    rofi_pid=$!
    sleep 1
    kill "$rofi_pid"
}

cd /home/$USER/wallpapers

selected=$(ls | rofi -dmenu -theme "$theme")
echo "$selected"

if [ -z "$selected" ]; then
    show_message "No wallpaper selected. Exiting without making any changes."
    exit 1
fi

if [[ "$selected" == *"gif" ]]; then
  # Set hyprlock.conf for GIF wallpaper
  sed -i "s|path=.*|path=/home/$USER/wallpapers/wal3.png|" /home/$USER/.config/hypr/hyprlock.conf
  swww img "/home/$USER/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
  show_message "Success :: wallpaper changed to $selected : Hyprlock wal set to wal3.png" -theme "$theme"
elif [[ "$selected" == *"jpg" ]]; then
  # Convert JPG to PNG and set as lockscreen wallpaper
  png_path="/home/$USER/wallpapers/lockscreen.png"
  ffmpeg -y -i "/home/$USER/wallpapers/$selected" "$png_path"
  sed -i "s|path=.*|path=$png_path|" /home/$USER/.config/hypr/hyprlock.conf
  swww img "/home/$USER/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
  show_message "Success :: wallpaper changed to $selected : Hyprlock wal set to lockscreen.png" -theme "$theme"
else
  # Set hyprlock.conf for non-GIF, non-JPG wallpaper
  sed -i "s|path=.*|path=/home/$USER/wallpapers/$selected|" /home/$USER/.config/hypr/hyprlock.conf
  swww img "/home/$USER/wallpapers/$selected" --transition-type random --transition-step 1 --transition-duration 2
  show_message "Success :: wallpaper changed to $selected!" -theme "$theme"
fi
