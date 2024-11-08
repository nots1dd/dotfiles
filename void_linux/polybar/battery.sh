#!/bin/bash
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)
percentage=$(echo "$battery" | grep -i "percentage" | awk '{print $2}')
status=$(echo "$battery" | grep -i "state" | awk '{print $2}')

if [[ "$status" == "discharging" ]]; then
  time_left=$(echo "$battery" | grep -i "time to empty" | awk '{print $4, $5}')
  echo " $percentage ($time_left) "
elif [[ "$status" == "charging" ]]; then
  echo " $percentage "
else
  echo "  No battery status "
fi
