#!/bin/bash

# Fetch the track name and artist using playerctl
track_name=$(playerctl --player=cmus metadata title 2>/dev/null)
artist=$(playerctl --player=cmus metadata artist 2>/dev/null)

# Fetch the current position (in seconds) using cmus-remote
position=$(cmus-remote -Q 2>/dev/null | grep 'position' | cut -d ' ' -f 2)

# Fetch the total duration (in seconds) using cmus-remote
duration=$(cmus-remote -Q 2>/dev/null | grep 'duration' | cut -d ' ' -f 2)

# Check if cmus is playing and if track details are available
if [ -n "$track_name" ] && [ -n "$artist" ] && [ -n "$duration" ] && [ -n "$position" ]; then
    # Format the track with artist: "song - artist"
    track_with_artist="$track_name - $artist"

    # Calculate the elapsed time (in mm:ss format)
    elapsed_minutes=$(($position / 60))
    elapsed_seconds=$(($position % 60))
    formatted_elapsed_time=$(printf "%02d:%02d" $elapsed_minutes $elapsed_seconds)

    # Calculate the total duration (in mm:ss format)
    total_minutes=$(($duration / 60))
    total_seconds=$(($duration % 60))
    formatted_total_duration=$(printf "%02d:%02d" $total_minutes $total_seconds)

    # Set the color and print the track with artist and time in "position / total duration" format
    echo "%{F$(xrdb -query | grep '*color7'| awk '{print $NF}')}$track_with_artist%{F-} |%{F$(xrdb -query | grep '*color5'| awk '{print $NF}')} $formatted_elapsed_time / $formatted_total_duration %{F-}"
else
    # If cmus is not playing, print "no track" with the appropriate color
    echo "%{F$(xrdb -query | grep '*color5'| awk '{print $NF}')}--:--%{F-}"
fi
