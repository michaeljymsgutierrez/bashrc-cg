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

if [ -f /proc/meminfo ]; then
  total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  free_mem=$(grep MemFree /proc/meminfo | awk '{print $2}')

  if [ -n "$total_mem" ] && [ -n "$free_mem" ] && [ "$total_mem" -gt 0 ] 2>/dev/null; then
    used_kb=$((total_mem - free_mem))
    mem_usage=$(awk "BEGIN {v=($used_kb / $total_mem) * 100; printf \"%.2f\", v}")
  else
    mem_usage="0"
  fi
else
page_size=$(sysctl -n hw.pagesize 2>/dev/null || echo 4096)
total_pages=$(sysctl -n hw.memsize 2>/dev/null | awk -v ps="$page_size" '{printf "%.0f", $1/ps}')
free_pages=$(vm_stat 2>/dev/null | awk '/Pages free:/ {gsub(/\./, ""); print $NF}')

  if [ -n "$total_pages" ] && [ -n "$free_pages" ] && [ "$total_pages" -gt 0 ] 2>/dev/null; then
    used_pages=$((total_pages - free_pages))
    mem_usage=$(awk "BEGIN {v=($used_pages / $total_pages) * 100; printf \"%.2f\", v}")
  else
    mem_usage="0"
  fi
fi

mem_usage=${mem_usage%.*}
if [ ${#mem_usage} -gt 2 ]; then
  mem_usage=${mem_usage:0:2}
fi

if [ "$mem_usage" -lt 0 ] 2>/dev/null; then mem_usage=0; fi
if [ "$mem_usage" -gt 100 ] 2>/dev/null; then mem_usage=100; fi

mem_usage=${mem_usage%.*}
if [ ${#mem_usage} -gt 2 ]; then
  mem_usage=${mem_usage:0:2}
fi

mem_icon="#[fg=#fde466,bg=#222222,bold]󰘚#[fg=#f8f1ff,bg=#222222,bold]"

percentage=""
for (( i=0; i<${#mem_usage}; i++ )); do
  digit="${mem_usage:$i:1}"
  case $digit in
    [0-9]) percentage+="${icons[$digit]}" ;;
  esac
done

if [ ${#mem_usage} -eq 1 ]; then
  mem_usage="0$mem_usage"
fi
echo "$mem_icon $percentage"
