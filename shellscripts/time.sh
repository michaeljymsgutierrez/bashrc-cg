#! /bin/bash

time_hours=$(date +"%I")
time_minutes=$(date +"%M")
time_period=$(date +"%p")

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

transform_two_digit_string_number_to_icon() {
  str="$1"
  first_digit_number=${str:0:1}
  second_digit_number=${str:1:1}
  first_digit_icon=${icons[$first_digit_number]}
  second_digit_icon=${icons[$second_digit_number]}
  echo "$first_digit_icon$second_digit_icon"
}


if [ $time_period -eq "AM" ]; then
  period="󰫮󱎥"
else
  period="󰫽󱎥"
fi

hours=$(transform_two_digit_string_number_to_icon "$time_hours")
minutes=$(transform_two_digit_string_number_to_icon "$time_minutes")

echo "$hours $minutes $period"
