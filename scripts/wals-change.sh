#!/bin/bash

# Script for selecting wallpapers (SUPER R)

# WALLPAPERS PATH
wallDIR="$HOME/wallpapers"
configDir="$HOME/dotfiles/rofi/wals/config-wallpaper.rasi"
png_path="$wallDIR/lockscreen.png"
theme="$HOME/dotfiles/rofi/wals/wal-config.rasi"
wallpaper="$HOME/wallpapers/.currentwal.png"

# Function to display a temporary message with rofi
show_message() {
    rofi -e "$1" -theme "$theme" &
    rofi_pid=$!
    sleep 1
    kill "$rofi_pid"
}

# Function to set Hyprlock wallpaper based on the selected wallpaper
# Was previously using sed to manually change hyprlock.conf, but now for simplicity, i set up a .currentwal.png in my walls dir
hyprlockSet() {
  if [[ "$selected" == *"gif" ]]; then
    # Set hyprlock.conf for GIF wallpaper
    ffmpeg -y -i "$selected" "$png_path"
    sed -i "s|path=.*|path=$png_path|" /home/$USER/.config/hypr/hyprlock.conf
    swww img "$selected" --transition-type random --transition-step 1 --transition-duration 2
    show_message "Success :: wallpaper changed to $selected : Hyprlock wal set to lockscreen.png" -theme "$theme"
  elif [[ "$selected" == *"jpg" ]]; then
    # Convert JPG to PNG and set as lockscreen wallpaper
    ffmpeg -y -i "$selected" "$png_path"
    # sed -i "s|path=.*|path=$png_path|" /home/$USER/.config/hypr/hyprlock.conf
    cp "$png_path" "$wallpaper"
    swww img "$wallpaper" --transition-type random --transition-step 1 --transition-duration 2
    show_message "Success :: wallpaper changed to $selected : Hyprlock wal set to lockscreen.png" -theme "$theme"
  else
    # Set hyprlock.conf for non-GIF, non-JPG wallpaper
    # sed -i "s|path=.*|path=$selected|" /home/$USER/.config/hypr/hyprlock.conf
    cp "$selected" "$wallpaper"
    swww img "$wallpaper" --transition-type random --transition-step 1 --transition-duration 2
    show_message "Success :: wallpaper changed to $selected!" -theme "$theme"
  fi
}

# Variables
SCRIPTSDIR="$HOME/.config/hypr/scripts"
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# swww transition config
TYPE="random"
DURATION=2
STEP=1
SWWW_PARAMS="--transition-type $TYPE --transition-step $STEP --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files using null delimiter to handle spaces in filenames
mapfile -d '' PICS < <(find "${wallDIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)


# Rofi command
rofi_command="rofi -i -show -dmenu -config $configDir"

# Sorting Wallpapers
menu() {
  # Sort the PICS array
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  
  
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "$pic_name" | grep -i "\.gif$") ]]; then
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    else
      printf "%s\n" "$pic_name"
    fi
  done
}

# Initiate swww if not running
swww query || swww-daemon --format xrgb

# Main function to choose wallpapers
main() {
  choice=$(menu | ${rofi_command})
  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Random choice case
  if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
    selected="$RANDOM_PIC"
    swww img -o $focused_monitor "$selected" $SWWW_PARAMS
    hyprlockSet
    exit 0
  fi

  # Find the index of the selected file
  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    selected="${PICS[$pic_index]}"
    swww img -o $focused_monitor "$selected" $SWWW_PARAMS
    hyprlockSet
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main
