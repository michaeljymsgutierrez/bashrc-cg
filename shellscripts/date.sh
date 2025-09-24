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

current_year=$(date +"%Y")
current_month=$(date +"%m")
current_date=$(date +"%d")

year=""
month=""
day=""
date_string=""

for (( i=0; i<${#current_year}; i++ )); do
  year_value="${current_year:$i:1}"
  year+=${icons[$year_value]}
done

for (( i=0; i<${#current_month}; i++ )); do
  month_value="${current_month:$i:1}"
  month+=${icons[$month_value]}
done

for (( i=0; i<${#current_date}; i++ )); do
  date_value="${current_date:$i:1}"
  day+=${icons[$date_value]}
done

date_string+=$year
date_string+="·"
date_string+=$month
date_string+="⋅"
date_string+=$day

echo " $date_string"
