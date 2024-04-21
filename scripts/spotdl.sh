#!/bin/bash

# Assign theme variable
theme="/home/s1dd/Downloads/rofi/files/launchers/type-4/style-1.rasi"

# Launch Rofi and capture input text
text=$(rofi -dmenu -p "Song Link" -theme "$theme")

# Check if text is not empty
if [ -n "$text" ]; then
    # Check if the text contains "https://open.spotify.com/"
    if [[ $text == *"https://open.spotify.com/"* ]]; then
        rofi -e "Text contains 'https://open.spotify.com/'" -theme "$theme"
        # Run the command with the provided text
        pipx run spotdl download "$text"
        if [ $? -eq 0 ]; then
            # Show a Rofi popup indicating the command is done
            rofi -e "Success" -theme "$theme"
        else
            # Show a Rofi popup indicating the command failed
            rofi -e "Failed. Try again. Exiting.." -theme "$theme"
        fi
    else
        rofi -e "Text does not contain 'https://open.spotify.com/'. Exiting.." -theme "$theme"
        echo "Exiting."
    fi
else
    rofi -e "No text provided. Exiting." -theme "$theme" -mesg "No action."
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



