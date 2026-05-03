#! /bin/bash

progress_icons=("󰇧" "" "" "")
STATE_FILE="/tmp/earth_progress_index"

index=$(cat "$STATE_FILE" 2>/dev/null || echo 0)

if [[ "$index" -ge "${#progress_icons[@]}" ]]; then
  index=0
fi

current_icon="${progress_icons[$index]}"

next_index=$(( (index + 1) % ${#progress_icons[@]} ))
echo "$next_index" > "$STATE_FILE"

echo "#[fg=#fde466,bg=#222222,bold]$current_icon#[fg=#f8f1ff,bg=#222222,bold]"
