#! /bin/bash

# @params $1: APP_NAME
# @params $2: ICON_PATH
# set-icon.sh Slack /usr/share/pixmaps/slack.png

# Note: Make sure xseticon is installed on your system
# If not installed: https://github.com/xeyownt/xseticon
# Either/usr/bin or /usr/local/bin is fine for script directory
# sudo cp set-icon.sh /usr/bin
# sudo chmod 777 /usr/bin/set-icon.sh

# Example usage on application.desktop
# Exec=/usr/bin/slack %U && set-icon.sh Slack /usr/share/pixmaps/slack.png

# Example usage on command line
# set-icon.sh Slack /usr/share/pixmaps/slack.png

sleep 15
window_details=$(wmctrl -l | grep $1)
read -a window_id <<< $window_details
xseticon -id $window_id $2

