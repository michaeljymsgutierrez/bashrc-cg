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

unread_mail_notification=$(osascript -e 'tell application "Mail" to get unread count of inbox')

unread_notification=""

if [ $unread_mail_notification -eq 0 ]; then
  unread_notification="#[fg=#f8f1ff,bg=#222222,bold]󰛮#[fg=#f8f1ff,bg=#222222,bold]"
fi

if [ $unread_mail_notification -gt 0 ]; then
  unread_notification="#[fg=#fde466,bg=#222222,bold]󰶍#[fg=#f8f1ff,bg=#222222,bold]"
fi

for (( i=0; i<${#unread_mail_notification}; i++ )); do
  notification_value="${unread_mail_notification:$i:1}"
  unread_notification+=${icons[$notification_value]}
done

echo "$unread_notification"
