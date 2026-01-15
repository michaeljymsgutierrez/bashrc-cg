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

unread_calendar_notification=$(osascript <<'EOT'
    set calendarBadge to 0
    tell application "System Events"
        tell process "Dock"
            try
                -- Target the specific Calendar UI element
                set badgeValue to value of attribute "AXStatusLabel" of UI element "Calendar" of list 1

                -- Check if the badge has a value and isn't empty
                if badgeValue is not missing value and badgeValue is not "" then
                    set calendarBadge to badgeValue as integer
                end if
            on error
                -- Calendar isn't in the Dock or Accessibility is blocked
                set calendarBadge to 0
            end try
        end tell
    end tell
    return calendarBadge
EOT
)


unread_notification=""

if [ $unread_calendar_notification -eq 0 ]; then
  unread_notification="#[fg=#f8f1ff,bg=#222222,bold]󰃗"
fi

if [ $unread_calendar_notification -gt 0 ]; then
  unread_notification="#[fg=#fde466,bg=#222222,bold]󱃐"
fi

for (( i=0; i<${#unread_calendar_notification}; i++ )); do
  notification_value="${unread_calendar_notification:$i:1}"
  unread_notification+=${icons[$notification_value]}
done


echo "$unread_notification"
