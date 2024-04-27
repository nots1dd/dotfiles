#!/bin/bash

# Assign theme variable
theme="~/dotfiles/rofi/spotdl/spotdl.rasi"

# Launch Rofi and capture input text
text=$(rofi -dmenu -p "Song Link :: " -theme "$theme")

show_message() {
    rofi -e "$1" -theme "$theme" &
    rofi_pid=$!
    sleep 1
    kill "$rofi_pid"
}

# Check if text is not empty
if [ -n "$text" ]; then
    # Check if the text contains "https://open.spotify.com/"
    if [[ $text == *"https://open.spotify.com/"* ]]; then
        show_message "Seems like valid link! Downloading..."
        # Run the command with the provided text
        cd ~/Downloads/Songs

        output=$(pipx run spotdl download "$text" 2>&1)
        if [ $? -eq 0 ]; then
            # Show a Rofi popup indicating the command is done
            song_name=$(printf "%s\n" "$output" | tail -n 1)
            show_message "~/Downloads/Songs: Success! 
$song_name"

            # updating cmus
            ~/dotfiles/scripts/cmus-lib-update.sh

            show_message "~/Downloads/Songs: Track added to CMUS!"
        else
            # Show a Rofi popup indicating the command failed
            failed=$(printf "%s" "$output" | tail -n 1)
            show_message "~/Downloads/Songs: Failed.

$failed 
Try again! "
        fi
    else
        show_message "Invalid Song format. 
Exiting.."
        echo "Exiting."
    fi
else
    show_message "No text provided. 
Exiting.."
fi



#!/bin/bash

# Function to launch Rofi with the given message
# launch_rofi() {
#     rofi_command="rofi -dmenu -p \"$1\" -theme '/home/s1dd/dotfiles/rofi/bluetooth-config.rasi'"
#     if [ "$2" ]; then
#         rofi_command="$rofi_command -mesg \"$2\" -theme '/home/s1dd/dotfiles/rofi/bluetooth-config.rasi'"
#     fi
#     if [ "$3" ]; then
#         rofi_command="$rofi_command -u $3 -theme '/home/s1dd/dotfiles/rofi/bluetooth-config.rasi'"
#     fi
#     echo "$rofi_command"
#     eval "$rofi_command"
# }

# # Initial prompt to enter text
# text=$(launch_rofi "Song")

# # Check if text is not empty
# if [ -n "$text" ]; then
#     # Check if the text contains "https://open.spotify.com/"
#     if [[ $text == *"https://open.spotify.com/"* ]]; then
#         # Display confirmation and execute the command
#         launch_rofi "Text contains 'https://open.spotify.com/'" "Running pipx command with provided text: $text" 1
#         # Run the command with the provided text in the background
#         pipx run spotdl download "${text}" 
#     else
#         # Display message and provide option to go back
#         selection=$(launch_rofi "Invalid Format" 1)
#         # Check if the Escape key was pressed
#         if [ $? -ne 0 ]; then
#             echo "Exiting."
#             exit 0
#         else
#             # Restart the script to go back to the initial prompt
#             exec "$0"
#         fi
#     fi
# else
#     # Display message and provide option to go back
#     selection=$(launch_rofi "No text provided." 1)
#     # Check if the Escape key was pressed
#     if [ $? -ne 0 ]; then
#         echo "Exiting. No text given."
#         exit 0
#     else
#         # Restart the script to go back to the initial prompt
#         exec "$0"
#     fi
# fi



