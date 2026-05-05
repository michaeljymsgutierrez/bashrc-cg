#! /bin/bash

connecting_icons=("󰤟" "󰤢" "󰤥")
connected_icons=("󰤡" "󰤤" "󰤧" "󰤪")
disconnected_icons=("󰤠" "󰤣" "󰤦" "󰤩")

STATE_FILE="/tmp/net_progress_index"

index=$(cat "$STATE_FILE" 2>/dev/null || echo 0)

if ping -c 2 google.com > /dev/null ; then
  current_icon="${connected_icons[$index]}"
  output="#[fg=#fde466,bg=#222222,bold]$current_icon #[fg=#f8f1ff,bg=#222222,bold]󰫰󰫻"
else
  current_icon="${disconnected_icons[$index]}"
  output="#[fg=#fa618d,bg=#222222,bold]$current_icon #[fg=#f8f1ff,bg=#222222,bold]󰫱󰫰"
fi

next_index=$(( (index + 1) % 4 ))
echo "$next_index" > "$STATE_FILE"

echo "$output"

