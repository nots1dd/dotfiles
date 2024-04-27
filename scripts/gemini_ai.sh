#!/bin/bash

source /home/s1dd/dotfiles/keys.sh # create your own keys.sh with YOUR OWN API KEY to use this script (you cant have mine sorry)

# Define the API endpoint and your API key
API_ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$API_KEY"
theme="~/dotfiles/rofi/launchers/type-4/style-1.rasi"
newtheme="~/dotfiles/rofi/aiClipboard/ai-clipboard-config.rasi"

show_message() {
    rofi -e "$1" -theme "$newtheme" &
    rofi_pid=$!
    sleep 1
    kill "$rofi_pid"
}

# If you want a more descriptive rofi

# show_intro() {
#     rofi -e "$1" -theme "$theme" &
#     rofi_pid=$!
#     sleep 2
#     kill "$rofi_pid"
# }

# intro=$(show_intro "GEMINI AI:
# Note :: This is only a one prompt function, history and conversations do not work!")

while true; do
    # Show input text field using Rofi
    prompt_text=$(rofi -dmenu -p " GEMINI ::" -theme "$newtheme")

    # exiting with escape keybind
    if [ $? -ne 0 ]; then
        show_message "Exiting without any prompts.."
        break
    fi

    # Send request to Gemini API using curl
    response=$(curl -s -H 'Content-Type: application/json' -d "{\"contents\":[{\"parts\":[{\"text\":\"$prompt_text\"}]}]}" -X POST "$API_ENDPOINT")

    # Extract text output from the JSON response and limit the number of lines
    text=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')
    text_output=$(echo "$text" | head -n 15) # can change 25 to any value as you choose, more than 40 can clutter your screen

    # Display the text output using Rofi
    echo "$text_output" | rofi -e "𐓙  GEMINI:

$text_output

.....
For more output, click Copy and Quit in the menu!" -theme "$newtheme"

    # Prompt user to continue or quit
#     continue_prompt=$(echo -e "Continue\nQuit" | rofi -dmenu -p "1. Start new prompt {any key}
# 2. Quit without copying {q!}
# 3. Quit with copying the latest conversation {wq}" -theme "$theme")

#     # Check user's choice
#     if [ "$continue_prompt" == "q!" ]; then
#         show_message "Exiting without copying!"
#         break
#     elif [ "$continue_prompt" == "wq" ]; then
#         echo "$text" | wl-copy --trim-newline
#         show_message "Copied to clipboard! Exiting!!"
#         break
#     fi
    continue=$(echo "Continue" )
    copyquit=$(echo "Copy and Quit")
    quit=$(echo "Quit")
    action="$continue\n$copyquit\n$quit"
    chosen="$(echo -e $action | rofi -dmenu -p "GEMINI MENU ::" -no-fixed-num-lines -yoffset -100 -i -theme $newtheme)"

    # Check user's action
    case "$chosen" in
        "$continue")
            show_message "Redirecting.."
            ;;
        "$copyquit")
            echo "$text" | wl-copy --trim-newline
            show_message "Copied to clipboard! Exiting!!"
            break
            ;;
        "$quit")
            show_message "Exiting without copying!"
            break
            ;;
    esac
done

