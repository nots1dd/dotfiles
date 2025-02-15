#!/bin/bash

if [ "$#" -eq 0 ]; then
    nvim
    exit
fi

file_path="$1"

# Get absolute path
abs_path=$(realpath "$file_path")

# Extract parent directory
dir_path=$(dirname "$abs_path")

# Extract filename
filename=$(basename "$abs_path")

# Change into the parent directory
cd "$dir_path" || exit

# Open file with nvim
nvim "$filename"
