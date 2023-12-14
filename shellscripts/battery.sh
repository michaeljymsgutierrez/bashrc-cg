#! /bin/bash

battery_percentage=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
battery_state=$(pmset -g ps|sed -nE "s|.*'(.*) Power.*|\1|p")

if [ "$battery_state" == "AC" ]; then
  battery_state_icon="󱊦"
else
  battery_state_icon="󱊣"
fi

if [ -z "$battery_percentage" ]; then
  echo "$battery_state_icon 100%"
else
  echo "$battery_state_icon $battery_percentage%"
fi
