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

unread_mail_count=$(osascript -e 'tell application "Mail" to get unread count of inbox')

mail_count=""

for (( i=0; i<${#unread_mail_count}; i++ )); do
  mail_value="${unread_mail_count:$i:1}"
  mail_count+=${icons[$mail_value]}
done

echo "$mail_count"

