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

cpu_cores=$(sysctl -n hw.logicalcpu)
cpu_usage=$(ps -A -o %cpu | awk -v cores="$cpu_cores" '{sum+=$1} END {printf "%.0f", sum/cores}')

if [ "$cpu_usage" -lt 0 ] 2>/dev/null; then cpu_usage=0; fi
if [ "$cpu_usage" -gt 99 ] 2>/dev/null; then cpu_usage=99; fi

if [ ${#cpu_usage} -eq 1 ]; then
  cpu_usage="0$cpu_usage"
fi

cpu_icon="#[fg=#fde466,bg=#222222,bold]󰍛#[fg=#f8f1ff,bg=#222222,bold]"

percentage=""
for (( i=0; i<${#cpu_usage}; i++ )); do
  digit="${cpu_usage:$i:1}"
  case $digit in
    [0-9]) percentage+="${icons[$digit]}" ;;
  esac
done

echo "$cpu_icon $percentage"
