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

unread_system_notification=$(osascript <<'EOT'
  set totalCount to 0
  tell application "System Events"
      tell process "Dock"
          try
              -- Get every icon currently in the Dock
              set allDockItems to UI elements of list 1
              repeat with anItem in allDockItems
                  try
                      -- Get the red badge value for the current icon
                      set badgeValue to value of attribute "AXStatusLabel" of anItem

                      -- If the badge exists and contains a number, add it to the total
                      if badgeValue is not missing value and badgeValue is not "" then
                          set totalCount to totalCount + (badgeValue as integer)
                      end if
                  on error
                      -- Ignore items that dont have badges
                  end try
              end repeat
          on error
              return 0
          end try
      end tell
  end tell
  return totalCount
EOT
)


unread_notification=""

if [ $unread_system_notification -eq 0 ]; then
  unread_notification="#[fg=#f8f1ff,bg=#222222,bold]"
fi

if [ $unread_system_notification -gt 0 ]; then
  unread_notification="#[fg=#fde466,bg=#222222,bold]"
fi

for (( i=0; i<${#unread_system_notification}; i++ )); do
  notification_value="${unread_system_notification:$i:1}"
  unread_notification+=${icons[$notification_value]}
done


echo "$unread_notification"

