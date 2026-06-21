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

total_mem=$(sysctl -n hw.memsize)
page_size=$(sysctl -n hw.pagesize)

mem_usage=$(vm_stat | awk -v total="$total_mem" -v ps="$page_size" '
  /Pages active:/     { gsub(/\./, ""); active=$NF }
  /Pages wired down:/ { gsub(/\./, ""); wired=$NF }
  END { printf "%.0f", (active + wired) * ps / total * 100 }
')

if [ "$mem_usage" -lt 0 ] 2>/dev/null; then mem_usage=0; fi
if [ "$mem_usage" -gt 99 ] 2>/dev/null; then mem_usage=99; fi

if [ ${#mem_usage} -eq 1 ]; then
  mem_usage="0$mem_usage"
fi

mem_icon="#[fg=#fde466,bg=#222222,bold]󰘚#[fg=#f8f1ff,bg=#222222,bold]"

percentage=""
for (( i=0; i<${#mem_usage}; i++ )); do
  digit="${mem_usage:$i:1}"
  case $digit in
    [0-9]) percentage+="${icons[$digit]}" ;;
  esac
done

echo "$mem_icon $percentage"
