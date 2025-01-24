tm_bg="#444444"
pane_text_color="#f8f1ff"
pane_background_color="#222222"
active_pane_border_color="#fde466"
tab_pointer_background_color="#fde466"

set -g mode-style "fg=$pane_text_color,bg=$tm_bg"

set -g message-style "fg=$pane_text_color,bg=$pane_background_color"
set -g message-command-style "fg=$pane_text_color,bg=$tm_bg"

set -g pane-border-style "fg=$tm_bg"
set -g pane-active-border-style "fg=$active_pane_border_color"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=$pane_text_color,bg=$pane_background_color"

set -g status-left-length "190"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

tm_time='#(bash -c ~/bashrc-cg/shellscripts/time.sh)'
tm_date='#(bash -c ~/bashrc-cg/shellscripts/date.sh)'
tm_datetime="$tm_time $tm_date"
tm_battery_status='#(bash -c ~/bashrc-cg/shellscripts/battery.sh)'
tm_network_status='#(bash -c ~/bashrc-cg/shellscripts/network.sh)'
tm_session="#[fg=$pane_text_color,bg=$pane_background_color,bold] $tm_network_status "
tm_win_name="#(bash -c '~/bashrc-cg/shellscripts/iconize-string.sh #W')"

tm_left_section="$tm_session "
tm_right_section="#[fg=$pane_text_color,bg=$pane_background_color] $tm_datetime $tm_battery_status "

set -g status-left "$tm_left_section"
set -g status-right "$tm_right_section"

setw -g window-status-activity-style "underscore,fg=$pane_text_color,bg=$pane_background_color"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=$pane_text_color,bg=$pane_background_color"

tm_win_inactive="#[default]$tm_win_name "
tm_win_active="#[fg=$pane_text_color,bg=$pane_background_color,bold]$tm_win_name #[fg=$tab_pointer_background_color,bg=$pane_background_color]󰩔 "

setw -g window-status-format "$tm_win_inactive "
setw -g window-status-current-format "$tm_win_active"
