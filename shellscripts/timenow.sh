#! /bin/bash

notation="$(date  +"%p")"
current_time="`date "+%I:%M:%S"`"

notify-send "Time Check" "$current_time $notation"
