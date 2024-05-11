# Check for `acpi` or `upower` command availability
if ! command -v acpi &> /dev/null && ! command -v upower &> /dev/null; then
  echo "Error: Neither acpi nor upower is installed. Install one of them for battery monitoring."
  return 1
fi

# Determine battery path using a safer method
battery_path="/sys/class/power_supply/$(ls /sys/class/power_supply/ | grep -E '^BAT[0-9]')"  # Handle multiple batteries
if [ ! -d "$battery_path" ]; then
  echo "Error: Battery path not found. Script may not work on your system."
  return 1
fi

# Function to get battery level (works with both acpi and upower)
get_battery_level() {
  if command -v acpi &> /dev/null; then
    # Use acpi for systems that support it
    battery_level=$(acpi -b | awk '{print $4}' | sed 's/,//' | sed 's/%//')
  else
    # Use upower as a fallback
    battery_level=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}')
  fi
  # Check for errors during data retrieval (added line)
  if [ -z "$battery_level" ]; then
      echo "Error: Failed to get battery level."
      return 1
  fi
  echo "$battery_level"
}
get_battery_state() {
  if command -v acpi &> /dev/null; then
    # Use acpi for systems that support it
    charging_state=$(acpi -b | awk '{print $3}' | sed 's/,//')
  else
    # Use upower as a fallback
    charging_state=$(upower -i $(upower -e | grep 'BAT') | grep "state" | awk '{print $2}')
  fi
  # Check for errors during data retrieval (added line)
  echo "$charging_state"
}

# Get current battery level and charging state
current_level=$(get_battery_level)
charging_state=$(get_battery_state) #format is fine
echo "$charging_state"

# Check battery level and send notification if below 20%
if [ "$current_level" -eq 100 ] && [ "$charging_state" == "Full" ]; then
notify-send "Fully-charged!" --icon=/home/s1dd/battery.png --expire-time=5000
else
 if [ "$current_level" -lt 20 ] && [ "$charging_state" != "Charging" ]; then
  # Ensure notify-send is installed (optional, comment out if not needed)
  # if ! command -v notify-send &> /dev/null; then
  #   echo "Warning: notify-send is not installed. Script cannot send notifications."
  # fi

  # Customize notification message and icon path (if desired)
  # echo "$current_level" && echo "$charging_state"
  brightnessctl set 30%-
  notify-send "$current_level% :: LOW BATTERY!" --icon=/home/s1dd/battery.png --expire-time=5000 --urgency=critical #in ms
else
  # Battery level is normal (above 20%)
  # echo "$current_level"
  echo "$current_level% :: $charging_state. Enjoy your freedom!"
 fi
fi


# this script is a very general script that should be usable for any local machine willing to execute it
# in theory, you can just cat the battery percentage and then an if statement is enough
# but this script is lengthy as it checks for existing bat file and performs checks before executing any command