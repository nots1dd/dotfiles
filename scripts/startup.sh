#!/bin/bash 

eval "$(zoxide init zsh)"

pls() {
    gum input --password --placeholder "Password pls" --cursor.foreground=101 --cursor.mode=static --cursor.background=101 --header "sudo" --header.foreground=106 | command sudo -S "$@"
}

## git related stuff 

gits() {
    git status | gum style --border double --border-foreground 106 --padding "1 2" --margin "1" --foreground 99
}

gitc() {
    commit_message=$(gum input --placeholder "Enter commit message" --header "Git Commit" --cursor.foreground=101 --header.foreground=106)
    
    if [ -z "$commit_message" ]; then
        gum style --foreground 196 "Commit message cannot be empty!"
    else
        gum confirm "Are you sure you want to commit with message: '$commit_message'?" && git commit -m "$commit_message" && gum style --foreground 118 "Commit successful!"
    fi
}

gita() {
    selected_files=$(git status -s | awk '{print $2}' | gum choose --no-limit --header "Select files to add" --placeholder "Choose files" --cursor.foreground=99)
    
    if [ -z "$selected_files" ]; then
        gum style --foreground 196 "No files selected."
    else
        echo "$selected_files" | xargs git add
        gum style --foreground 118 "Files added successfully!"
    fi
}

gita.() {
  git add .
}

