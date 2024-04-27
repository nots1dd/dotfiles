#!/bin/bash
MODE="$(hyprctl activewindow | grep 'fullscreenmode:' | awk -F': ' '{ print $2 }')"
FULLSCRN="$(hyprctl activewindow | grep -e '\sfullscreen:' | awk -F'fullscreen: ' '{ print $2 }')"
EXIT=0
case $FULLSCRN in
    0) 
    hyprctl dispatch fullscreen 1
    exit;;
    1)
    case $MODE in
        1) 
        hyprctl dispatch fullscreen 0
        hyprctl dispatch fullscreen 0
        exit;;
        0)
        hyprctl dispatch fullscreen 0
        exit;;
    esac
    exit;;
esac
