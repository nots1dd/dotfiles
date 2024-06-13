# written by nots1dd

#!/bin/bash

rofi='/home/s1dd/dotfiles/rofi/playing.rasi'
# Function to send notification using notify-send
send_notification() {
    notif=$(dunstify "Now Playing" "$1" --icon=/home/s1dd/tmp.png --timeout=4000 -p)
    sleep 4
    dunstify -C $notif # you can not do this if you want but i dont like the notification staying
}

# Function to control playerctl
control_playerctl() {
    playerctl_status=$(playerctl status 2>/dev/null)
    if [ "$playerctl_status" = "Playing" ] || [ "$playerctl_status" = "Paused" ]; then
        playerctl metadata --format "{{title}} - {{artist}}" -i firefox
    fi
}

# Function to extract cover image
extract_cover() {
    input_file="$1"
    temp_dir=$(mktemp -d)
    ffmpeg -y -i "$input_file" -an -vcodec copy "$temp_dir/cover.png" >/dev/null 2>&1
    echo "$temp_dir/cover.png"
}

cover_success() {
    echo "Cover image extracted!"
}

# Function to copy cover image to ~/tmp.png
copy_to_tmp() {
    cp "$1" ~/tmp.png
    # convert -resize 40% tmp.png new.png
    # echo "Resized image to ~/new.png!"
}

# launch_rofi() {
#     echo "Launching Rofi with background image..."
# }
# show_message() {
#     play=$(playerctl status 2>/dev/null)
#     if [ "$play" = "Playing" ]; then
#     # killall rofi # kills the previous instance of rofi before displaying (more than 1 rofi cannot work anyway so it will not interfere with other scripts dw)
#     # echo " ⏵  $1" | rofi -location 1 -xoffset 1024 -yoffset 520 -dmenu -theme "$rofi" &
#     # rofi_pid=$!
#     # sleep 2
#     # kill "$rofi_pid"
#     fi
#     # if [ "$play" = "Paused" ]; then
#     # echo " ⏸  $1" | rofi -location 1 -xoffset 1024 -yoffset 520 -dmenu -theme "$rofi" &
#     # fi
# }

# Function to clean up temporary directory
cleanup_temp_dir() {
    rm -rf "$1"
    echo "tmp image removed!"
}

success() {
    echo "OVERVIEW
SONG: $mp3_file
-> EXTRACTION OF IMAGE ✔
-> CREATED TMP DIR  ✔
-> INTERMEDIATE PROCESSES DONE ✔
-> DELETED TMP DIR ✔
-> EXITED SUCCESSFULLY"
}

# Store initial song information
prev_song=""
prev_status=""

# Main loop
while true; do
    # Check if playerctl is available
    playerctl_status=$(command -v playerctl)
    if [ -n "$playerctl_status" ]; then
        song_info=$(control_playerctl)
        player_status=$(playerctl status 2>/dev/null)
        if [ -n "$song_info" ] && ([ "$song_info" != "$prev_song" ] ); then #|| [ "$player_status" != "$prev_status" ]); then
            # send_notification "$song_info"
            artist=$(echo "$song_info" | awk -F ' - ' '{print $1}')
            song_name=$(echo "$song_info" | awk -F ' - ' '{print $2}')
            mp3_file="${song_name// / } - ${artist// / }.mp3"
            cd ~/Downloads/Songs || exit 1
            cover_image=$(extract_cover "$mp3_file")
            cover_success
            copy_to_tmp "$cover_image"
            prev_song="$song_info"
            # launch_rofi
            # show_message "$artist - $song_name" # need to kill after 2 secs
            send_notification "$song_info"
            echo "SCAN DONE CHECK ~/tmp.png!"
            cleanup_temp_dir "$(dirname "$cover_image")"
            success
            cd - >/dev/null || exit 1
        fi
        prev_status="$player_status"
    fi

    # Delay before checking again
    sleep 1
done

## NOTE:
# If ffmpeg is not able to extract the image (thumbnail might not exist), it will return an error "Output stream not found"
# ^^ this leads to the BACKGROUND IMAGE STAYING THE SAME, modify it as you wish to show that there was an error but for me this was NOT a big deal
