#!/bin/bash

# Check Wi-Fi status
wifi_status=$(nmcli -t -f WIFI g)
wifi_connected_icon=""
wifi_disconnected_icon="睊"
if [[ "$wifi_status" == "enabled" ]]; then
    wifi_icon=$wifi_connected_icon
else
    wifi_icon=$wifi_disconnected_icon
fi

# Check Bluetooth status
bluetooth_status=$(bluetoothctl show | grep "Powered: yes" | wc -l)
bluetooth_connected_icon=""
bluetooth_disconnected_icon="󰂲"
if [[ "$bluetooth_status" -gt 0 ]]; then
    bluetooth_icon=$bluetooth_connected_icon
else
    bluetooth_icon=$bluetooth_disconnected_icon
fi

# Check Audio status
audio_info=$(amixer get Master | grep -Eo '[0-9]+%' | head -1 | sed 's/%//')  # Get the current volume percentage
audio_on_icon=""
audio_off_icon=""
if [[ "$audio_info" -gt 0 ]]; then
    audio_icon=$audio_on_icon
else
    audio_icon=$audio_off_icon
    audio_info=""
fi


# Display the icons for Wi-Fi, Bluetooth, and Audio
echo -e "[ $wifi_icon  $bluetooth_icon $audio_icon  ]"
