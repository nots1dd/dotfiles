#!/bin/bash

workspaces_active=$(hyprctl workspaces -j | jq '. | length')

echo " $USER: $workspaces_active win"


