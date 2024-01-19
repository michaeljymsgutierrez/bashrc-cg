#! /bin/bash

battery_percentage=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
battery_state=$(pmset -g ps|sed -nE "s|.*'(.*) Power.*|\1|p")

if [ "$battery_state" == "AC" ]; then
  plug_state_icon="󰚥"
else
  plug_state_icon="󰚦"
fi

if [ $battery_percentage -ge 1 ] && [ $battery_percentage -le 25 ]; then
  battery_state_icon=" "
elif [ $battery_percentage -ge 25 ] && [ $battery_percentage -le 50 ]; then
  battery_state_icon=" "
elif [ $battery_percentage -ge 51 ] && [ $battery_percentage -le 75 ]; then
  battery_state_icon=" "
elif [ $battery_percentage -ge 76 ] && [ $battery_percentage -le 100 ]; then
  battery_state_icon=" "
else
  battery_state_icon=" "
fi

if [ -z "$battery_percentage" ]; then
  echo "$battery_state_icon 100%"
else
  echo "$plug_state_icon $battery_state_icon $battery_percentage%"
fi
