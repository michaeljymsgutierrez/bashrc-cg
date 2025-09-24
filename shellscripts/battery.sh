#!/bin/bash

icons[0]="󰬹"
icons[1]="󰬺"
icons[2]="󰬻"
icons[3]="󰬼"
icons[4]="󰬽"
icons[5]="󰬾"
icons[6]="󰬿"
icons[7]="󰭀"
icons[8]="󰭁"
icons[9]="󰭂"

battery_percentage=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
battery_state=$(pmset -g ps|sed -nE "s|.*'(.*) Power.*|\1|p")

battery_percentage_icon=""
battery_state_icon=""
battery_status="󰫯󰫮󰬁⋅"

if [ $battery_percentage -ge 1 ] && [ $battery_percentage -le 10 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰢜"
  else
    battery_state_icon="󰁺"
  fi
elif [ $battery_percentage -ge 11 ] && [ $battery_percentage -le 20 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰂆"
  else
    battery_state_icon="󰁻"
  fi
elif [ $battery_percentage -ge 21 ] && [ $battery_percentage -le 30 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰂇"
  else
    battery_state_icon="󰁼"
  fi
elif [ $battery_percentage -ge 31 ] && [ $battery_percentage -le 40 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰂈"
  else
    battery_state_icon="󰁽"
  fi
elif [ $battery_percentage -ge 41 ] && [ $battery_percentage -le 50 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰢝"
  else
    battery_state_icon="󰁾"
  fi
elif [ $battery_percentage -ge 51 ] && [ $battery_percentage -le 60 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰂉"
  else
    battery_state_icon="󰁿"
  fi
elif [ $battery_percentage -ge 61 ] && [ $battery_percentage -le 70 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰢞"
  else
    battery_state_icon="󰂀"
  fi
elif [ $battery_percentage -ge 71 ] && [ $battery_percentage -le 80 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰂊"
  else
    battery_state_icon="󰂁"
  fi
elif [ $battery_percentage -ge 81 ] && [  $battery_percentage -le 90 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰂋"
  else
    battery_state_icon="󰂂"
  fi
elif [ $battery_percentage -ge 91 ] && [  $battery_percentage -le 100 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="󰂅"
  else
    battery_state_icon="󰁹"
  fi
else
  battery_state_icon="󱃍"
fi

for (( i=0; i<${#battery_percentage}; i++ )); do
  battery_percentage_value="${battery_percentage:$i:1}"
  battery_percentage_icon+=${icons[$battery_percentage_value]}
done

if [ -z "$battery_percentage" ]; then
  echo "󰄌 󰫯󰫮󰬁⋅󰬺󰬹󰬹"
  # echo "󰂄 󰬺󰬹󰬹"
else
  # echo "$battery_state_icon $battery_percentage_icon"
  battery_status+="$battery_percentage_icon"
  echo "󰄌 $battery_status"
fi
