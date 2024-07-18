
#!/bin/bash

Bold="\033[1m"
Green="\033[32m"
Reset="\033[0m"

# Function to extract and format the date from the pacman log
extract_date() {
    last_update=$(strings /var/log/pacman.log | grep -i "pacman -S -y -u" | tail -1 | awk -F'[][]' '{print $2}')
    echo "$last_update"
}

to_update_pkgs() {
  yay -Sy > /dev/null 2>&1 
  pkgs=$(yay -Qu | wc -l)
  echo -e "No of packages to be updated: $pkgs"
}

# Function to prettify the date
prettify_date() {
    iso_date=$1
    pretty_date=$(date -d "$iso_date" +"%A, %B %d, %Y at %I:%M:%S %p %Z")
    echo "$pretty_date"
}

last_pacman_update=$(extract_date)


pretty_pacman_update=$(prettify_date "$last_pacman_update")
packages=$(to_update_pkgs)
zenity --info --text="Last system update (pacman):\n$pretty_pacman_update\n$packages"

