tm_bg="#444444"
tm_fg="#bcbcbc"
tm_bg_highlight="#313131"
tm_light_green="#afdf00"
tm_dark_green="#275e16"
tm_orange="#ff9700"
tm_black="#000001"
tm_light_black="#585858"
tm_white="#ffffff"
tm_border="#62d8f1"

set -g mode-style "fg=$tm_light_green,bg=$tm_bg"

set -g message-style "fg=$tm_light_green,bg=$tm_bg_highlight"
set -g message-command-style "fg=$tm_light_green,bg=$tm_bg"

set -g pane-border-style "fg=$tm_bg"
set -g pane-active-border-style "fg=$tm_border"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=$tm_light_green,bg=$tm_bg_highlight"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

tm_session="#[fg=$tm_dark_green,bg=$tm_light_green,bold] $tm_network_status "
tm_datetime=" %H:%M  %a-%d-%b-%y"
tm_battery_status='#(bash -c ~/bashrc-cg/shellscripts/battery.sh)'
tm_network_status='#(bash -c ~/bashrc-cg/shellscripts/network.sh)'
tm_host="#[fg=$tm_black,bg=$tm_fg,nobold] 󱩊  #h "

tm_left_section="$tm_session"
tm_right_section="#[fg=$tm_fg,bg=$tm_light_black] $tm_datetime #[fg=$tm_black,bg=$tm_fg,bold] $tm_battery_status "

set -g status-left "$tm_left_section"
set -g status-right "$tm_right_section"

setw -g window-status-activity-style "underscore,fg=$tm_fg,bg=$tm_bg_highlight"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=$tm_fg,bg=$tm_bg_highlight"

tm_win_inactive="#[default] #W"
tm_win_active="#[fg=$tm_white,bg=$tm_light_black,bold] #W #[fg=$tm_light_green,bg=$tm_light_black,bold] "

setw -g window-status-format "$tm_win_inactive "
setw -g window-status-current-format "$tm_win_active"
