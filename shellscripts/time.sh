#! /bin/bash

icons[0]="󰎡"
icons[1]="󰎤"
icons[2]="󰎧"
icons[3]="󰎪"
icons[4]="󰎭"
icons[5]="󰎱"
icons[6]="󰎳"
icons[7]="󰎶"
icons[8]="󰎹"
icons[9]="󰎼"

time_hours=$(date +"%I")
time_minutes=$(date +"%M")
time_period=$(date +"%p")

hours=""
minutes=""

for (( i=0; i<${#time_hours}; i++ )); do
  hour_value="${time_hours:$i:1}"
  hours+=${icons[$hour_value]}
done

for (( i=0; i<${#time_minutes}; i++ )); do
  minute_value="${time_minutes:$i:1}"
  minutes+=${icons[$minute_value]}
done

if [ "$time_period" == "AM" ]; then
  period="󰫮󱎥"
else
  period="󰫽󱎥"
fi

echo "$hours $minutes $period"
