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

if [ $battery_percentage -ge 1 ] && [ $battery_percentage -le 12 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪞#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪞"
  fi
elif [ $battery_percentage -ge 13 ] && [ $battery_percentage -le 25 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪟#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪟"
  fi
elif [ $battery_percentage -ge 26 ] && [ $battery_percentage -le 37 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪠#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪠"
  fi
elif [ $battery_percentage -ge 38 ] && [ $battery_percentage -le 50 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪡#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪡"
  fi
elif [ $battery_percentage -ge 51 ] && [ $battery_percentage -le 62 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪢#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪢"
  fi
elif [ $battery_percentage -ge 63 ] && [ $battery_percentage -le 75 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪣#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪣"
  fi
elif [ $battery_percentage -ge 76 ] && [ $battery_percentage -le 88 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪤#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪤"
  fi
elif [ $battery_percentage -ge 89 ] && [ $battery_percentage -le 100 ]; then
  if [ "$battery_state" == "AC" ]; then
    battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪥#[fg=#f8f1ff,bg=#222222,bold]"
  else
    battery_state_icon="󰪥"
  fi
else
  battery_state_icon="󰗖"
fi

for (( i=0; i<${#battery_percentage}; i++ )); do
  battery_percentage_value="${battery_percentage:$i:1}"
  battery_percentage_icon+=${icons[$battery_percentage_value]}
done

if [ -z "$battery_percentage" ]; then
  battery_state_icon="#[fg=#fde466,bg=#222222,bold]󰪥#[fg=#f8f1ff,bg=#222222,bold]"
  battery_percentage_icon="󰬺󰬹󰬹"
  echo "$battery_state_icon $battery_percentage_icon"
else
  echo "$battery_state_icon $battery_percentage_icon"
fi
