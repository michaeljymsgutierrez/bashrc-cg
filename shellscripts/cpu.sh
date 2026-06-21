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

if [ -f /proc/stat ]; then
  cpu_load=$(cat /proc/loadavg | awk '{print $1}')
  cpu_cores=$(grep -c processor /proc/cpuinfo)

  if [ "$cpu_cores" -gt 0 ] 2>/dev/null; then
    cpu_usage=$(awk "BEGIN {v=($cpu_cores - $cpu_load) / $cpu_cores * 100; printf \"%.2f\", v}")
  else
    cpu_usage="0.00"
  fi
  cpu_usage=${cpu_usage%.*}
  if [ ${#cpu_usage} -gt 2 ]; then
    cpu_usage=${cpu_usage:0:2}
  fi
else
  cpu_usage=$(top -l 1 | awk '/CPU usage:/ {gsub(/[^0-9.]/, "", $5); print $5}')

  if [ -z "$cpu_usage" ]; then
    cpu_usage=$(ps aux | awk 'NR>2 && $3!="-" {sum+=$3; n++} END {if(n>0) printf "%.0f", sum/n}')
  fi
fi
if [ "$cpu_usage" -lt 0 ] 2>/dev/null; then cpu_usage=0; fi
if [ "$cpu_usage" -gt 100 ] 2>/dev/null; then cpu_usage=100; fi

cpu_usage=${cpu_usage%.*}
if [ ${#cpu_usage} -gt 2 ]; then
  cpu_usage=${cpu_usage:0:2}
fi

cpu_icon="#[fg=#fde466,bg=#222222,bold]󰍛#[fg=#f8f1ff,bg=#222222,bold]"

percentage=""
for (( i=0; i<${#cpu_usage}; i++ )); do
  digit="${cpu_usage:$i:1}"
  case $digit in
    [0-9]) percentage+="${icons[$digit]}" ;;
  esac
done

if [ ${#cpu_usage} -eq 1 ]; then
  cpu_usage="0$cpu_usage"
fi
echo "$cpu_icon $percentage"