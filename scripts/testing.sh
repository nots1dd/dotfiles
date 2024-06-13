#!/bin/bash

# LITEMUS (Light music player)

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# written by nots1dd
# NOTE :: This script uses ffplay to play audio NOT PLAYERCTL
# HENCE, it will NOT work well with your current configs that use playerctl and such

# DEPENDENCIES
# 1. ffmpeg and its family tree (ffprobe, ffplay)
# 2. smenu
# 3. bc (basic calculator) [AUR PACKAGE]
# 4. viu (terminal image emulator) [AUR PACKAGE]
# 5. grep, awk, trap (very important basic unix tools)

clear
cd ~/Downloads/Songs

# Function to extract and display thumbnail
extract_cover() {
    input_file="$1"
    temp_dir=$(mktemp -d)
    ffmpeg -y -i "$input_file" -an -vcodec copy "$temp_dir/cover_new.png" >/dev/null 2>&1
    echo "$temp_dir/cover_new.png"
}

cover_success() {
    echo "Cover image extracted!"
}

copy_to_tmp() {
    cp "$1" ~/newtmp.png
    # echo "Copied!"
}

cleanup_temp_dir() {
    rm -rf "$1"
    # echo "tmp image removed!"
}

# Function to pause playback
pause_playback() {
    # Pause the playback by sending a SIGSTOP signal to the ffplay process
    kill -STOP "$ffplay_pid"
    echo -e "${YELLOW}Playback paused.${NC}"
}

# Function to resume playback
resume_playback() {
    # Resume the playback by sending a SIGCONT signal to the ffplay process
    kill -CONT "$ffplay_pid"
    echo -e "${GREEN}Playback resumed.${NC}"
}

# Function to display current song information
display_song_info() {
    local song="$1"
    local duration="$2"
    echo -e "\n${GREEN} $song (${YELLOW}$duration${NC})\n"
}

# Function to get duration of a song (ffprobe gets results in seconds ONLY that are floating of 0.6f degree ex. 255.000123)
get_duration() {
    local song="$1"
    time=$(ffprobe -v quiet -print_format json -show_format -show_streams "$song" | jq -r '.format.duration')
    # Convert duration to floating-point number
    duration_seconds=$(echo "$time" | bc -l)
    # Round duration_seconds to the nearest integer
    duration_seconds=$(printf "%.0f" "$duration_seconds") # (not doing this step leads to some weird results on my local machine, modify this function as you need)
    # Calculate minutes and seconds
    minutes=$((duration_seconds / 60))
    seconds=$((duration_seconds % 60))
    printf "%02d:%02d\n" "$minutes" "$seconds"
}

show_smenu() {
    smenu -c -n15 -W $'\n' -q -2 "$@" -m "Select Song"
}

# Store the selected artist in the variable "selected_artist"
play() {
    selected_artist=$(ls *.mp3 | awk -F ' - ' '{ artist = substr($1, 1, 512); gsub(/'\''/, "_", artist); print artist }' | sort -u | smenu -c -q -n30 -W $'\n' -m "Select Artist")
    if [ "$selected_artist" = "" ]; then
        exit
    else
    clear
    echo -e "${NC}You selected artist:${GREEN} $selected_artist\n"

    # Store the selected song in the variable "selected_song"
    selected_song=$(ls *.mp3 | grep "^$selected_artist" | show_smenu "^$selected_artist")

    # Clear the screen
    clear

    # Display the thumbnail of the selected song
    cover_image=$(extract_cover "/home/s1dd/Downloads/Songs/$selected_song")
    # echo $cover_image
    # cover_success
    copy_to_tmp "$cover_image"
    cleanup_temp_dir "$(dirname "$cover_image")"
    viu --width 35 --height 15 ~/newtmp.png
    # Get duration of the selected song
    duration=$(get_duration "$selected_song")

    # Display current song information
    display_song_info "$selected_song" "$duration"

    echo -e "${YELLOW}Pause (p)${NC}" "${GREEN}Resume (r)${NC}" "${RED}Quit (q)${NC}" "${YELLOW}Kill and go back to menu (s)${NC}" "${NC}Silently go back to menu (t)${NC}"

    # Play the selected song using ffplay in the background and store the PID
    killall ffplay
    ffplay -nodisp -autoexit "$selected_song" >/dev/null 2>&1 &
    ffplay_pid=$!
    fi
}
play

# Variable to track playback status (0 = playing, 1 = paused)
paused=0

# Trap the SIGINT signal (Ctrl+C) to exit the playback
trap exit SIGINT

# Loop to continuously handle user input
while true; do
    read -n 1 -s key
    case $key in
        p|P)
            if [[ $paused -eq 0 ]]; then
                pause_playback
                paused=1
            else
                resume_playback
                paused=0
            fi
            ;;
        r|R)
            if [[ $paused -eq 1 ]]; then
                resume_playback
                paused=0
            fi
            ;;
        s|S)
            # Return to song selection menu
            kill "$ffplay_pid" >/dev/null 2>&1
            clear
            play
            ;;
        t|T)
            # dont kill just play in bg
            echo "REDIRECTING..."
            clear
            play
            ;;
        q|Q)
            kill "$ffplay_pid" >/dev/null 2>&1
            echo -e "${RED}Exiting...${NC}"
            exit
            ;;
        *)
            continue
            ;;
    esac
done
