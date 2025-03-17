#!/usr/bin/env bash

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$XDG_CONFIG_HOME/ags"
WALLPAPERS_DIR=$HOME/wallpapers/

switch() {
    imgpath=$1
    read scale screenx screeny screensizey < <(hyprctl monitors -j | jq '.[] | select(.focused) | .scale, .x, .y, .height' | xargs)
    cursorposx=$(hyprctl cursorpos -j | jq '.x' 2>/dev/null) || cursorposx=960
    cursorposx=$(bc <<< "scale=0; ($cursorposx - $screenx) * $scale / 1")
    cursorposy=$(hyprctl cursorpos -j | jq '.y' 2>/dev/null) || cursorposy=540
    cursorposy=$(bc <<< "scale=0; ($cursorposy - $screeny) * $scale / 1")
    cursorposy_inverted=$((screensizey - cursorposy))

    if [ -z "$imgpath" ]; then
        echo 'Aborted'
        exit 0
    fi

    # ags run-js "wallpaper.set('')"
    # sleep 0.1 && ags run-js "wallpaper.set('${imgpath}')" &
    swww img "$imgpath" --transition-step 100 --transition-fps 120 \
        --transition-type grow --transition-angle 30 --transition-duration 1 \
        --transition-pos "$cursorposx, $cursorposy_inverted"

    # Check if the image is a JPEG and convert if necessary
    if file --mime-type "$imgpath" | grep -qE 'image/jpeg'; then
        temp_png=$(mktemp --suffix=.png)
        ffmpeg -i "$imgpath" -y "$temp_png" >/dev/null 2>&1
        cp -f "$temp_png" "$HOME/.config/hypr/hyprlock.png"
        rm -f "$temp_png"
    else
        cp -f "$imgpath" "$HOME/.config/hypr/hyprlock.png"
    fi
}

if [ "$1" == "--noswitch" ]; then
	imgpath=$(swww query | awk -F 'image: ' '{print $2}')
	# imgpath=$(ags run-js 'wallpaper.get(0)')
elif [[ "$1" ]]; then
	switch "$1"
else
	# Select and set image (hyprland)

    cd $WALLPAPERS_DIR || return 1
	switch "$(yad --width 1200 --height 800 --file --add-preview --large-preview --title='Choose wallpaper')"
fi

# Generate colors for ags n stuff
"$CONFIG_DIR"/scripts/color_generation/colorgen.sh "${imgpath}" --apply --smart
