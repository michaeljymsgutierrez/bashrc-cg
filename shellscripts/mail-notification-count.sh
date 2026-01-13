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

mail_count=""

if [ $unread_mail_count -eq 0 ]; then
  mail_count="#[fg=#f8f1ff,bg=#222222,bold]"
fi

if [ $unread_mail_count -gt 0 ]; then
  mail_count="#[fg=#fde466,bg=#222222,bold]"
fi

for (( i=0; i<${#unread_mail_count}; i++ )); do
  mail_value="${unread_mail_count:$i:1}"
  mail_count+=${icons[$mail_value]}
done

echo "$mail_count"

