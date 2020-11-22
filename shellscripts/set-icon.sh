#! /bin/bash

# @params $1: APP_NAME
# @params $2: ICON_PATH
# set-icon.sh Slack /usr/share/pixmaps/slack.png

# Note: Make sure xseticon is installed on your system
# if not installed: https://github.com/xeyownt/xseticon
# sudo cp set-icon.sh /usr/bin
# sudo chmod 777 /usr/bin/set-icon.sh

window_details=$(wmctrl -l | grep $1)
read -a window_id <<< $window_details

xseticon -id $window_id $2
