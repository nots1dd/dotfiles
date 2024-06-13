# !bin/bash

file=$(gum input --placeholder="Enter file to code")
code_dir="/home/$USER/misc/codeforces"

cd "$code_dir"
nvim "$file"


