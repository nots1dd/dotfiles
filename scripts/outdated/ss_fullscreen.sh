#!/bin/bash
case $1 in
    f)  hyprpicker -r -z & 
    sleep 0.2
    HYPRPICKER_PID=$!
    BOUNDS="$(slurp -o -r -c '#ff0000ff')"
    grim -g "$BOUNDS" /tmp/unsaved.png
    sleep 0.1
    kill $HYPRPICKER_PID
    wl-copy < /tmp/unsaved.png
    EDIT="$(dunstify -a "Skreenshot" --icon=/tmp/unsaved.png -A Y,Edit "Screenshot copied! 🎉")"
    case $EDIT in
        Y) satty --filename /tmp/unsaved.png --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png --copy-command wl-copy
        exit;;
    esac
    exit;;

    a) hyprpicker -r -z & 
    sleep 0.2
    HYPRPICKER_PID=$!
    BOUNDS="$(slurp -c '#ff0000ff')"
    grim -g "$BOUNDS" /tmp/unsaved.png
    sleep 0.1
    kill $HYPRPICKER_PID
    wl-copy < /tmp/unsaved.png
    EDIT="$(dunstify -a "Skreenshot" --icon=/tmp/unsaved.png -A Y,Edit "Screenshot copied! 🎉")"
    case $EDIT in
        Y) satty --filename /tmp/unsaved.png --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png --copy-command wl-copy
        exit;;
    esac    
    exit;;
esac

