#!/bin/bash

# Source your API key from an external file
source /home/s1dd/dotfiles/scripts/keys.sh

# Define constants
API_ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$API_KEY"
THEME="~/dotfiles/rofi/launchers/type-4/style-1.rasi"
NEWTHEME="~/dotfiles/rofi/aiClipboard/ai-clipboard-config.rasi"
PROMPT_ICON=" GEMINI ::"
EXIT_MESSAGE="Exiting without any prompts.."
MESSAGE_DURATION=1  # Duration to display messages

# Function to display messages using Rofi
show_message() {
    rofi -e "$1" -theme "$NEWTHEME" &
    rofi_pid=$!
    sleep $MESSAGE_DURATION
    kill "$rofi_pid"
}

# Function to send request to Gemini API and process the response
get_response() {
    local prompt_text="$1"
    curl -s -H 'Content-Type: application/json' \
         -d "{\"contents\":[{\"parts\":[{\"text\":\"$prompt_text\"}]}]}" \
         -X POST "$API_ENDPOINT"
}

# Function to extract and display the response in Rofi
display_response() {
    local response="$1"
    local text=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')
    local text_output=$(echo "$text" | head -n 15)
    echo "$text_output" | rofi -e "𐓙  GEMINI:
.....


$text_output

.....
For more output, click Copy and Quit in the menu!" -theme "$NEWTHEME"
}

# Main loop
while true; do
    # Display input prompt using Rofi
    prompt_text=$(rofi -dmenu -p "$PROMPT_ICON" -theme "$NEWTHEME")

    # Check if the user exited with the escape key
    if [ $? -ne 0 ]; then
        show_message "$EXIT_MESSAGE"
        break
    fi

    # Get and display the response from the Gemini API
    response=$(get_response "$prompt_text")
    display_response "$response"

    # Prompt user for next action
    action=$(echo -e "Continue\nCopy and Quit\nQuit (esc)" | rofi -dmenu -p "GEMINI MENU ::" -no-fixed-num-lines -yoffset -100 -i -theme "$NEWTHEME")
    
    # to kill rofi by pressing escape
    if [ $? -ne 0 ]; then
        show_message "$EXIT_MESSAGE"
        break
    fi
    # Handle user's choice
    case "$action" in
        "Continue")
            show_message "Redirecting.."
            ;;
        "Copy and Quit")
            echo "$text" | wl-copy --trim-newline
            show_message "Copied to clipboard! Exiting!!"
            break
            ;;
        "Quit")
            show_message "Exiting without copying!"
            break
            ;; 
        *)
            show_message "Invalid selection! Please try again."
            ;;
    esac
done
