tm_bg="#444444"
tm_fg="#a7b0d5"
tm_bg_highlight="#1a1b26"
tm_active_tab_pointer_bg="#7aa1f7"
tm_border="#62d8f1"

set -g mode-style "fg=$tm_fg,bg=$tm_bg"

set -g message-style "fg=$tm_fg,bg=$tm_bg_highlight"
set -g message-command-style "fg=$tm_fg,bg=$tm_bg"

set -g pane-border-style "fg=$tm_bg"
set -g pane-active-border-style "fg=$tm_border"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=$tm_fg,bg=$tm_bg_highlight"

set -g status-left-length "190"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

tm_time='#(bash -c ~/bashrc-cg/shellscripts/time.sh)'
tm_date='#(bash -c ~/bashrc-cg/shellscripts/date.sh)'
tm_datetime="$tm_time $tm_date"
tm_battery_status='#(bash -c ~/bashrc-cg/shellscripts/battery.sh)'
tm_network_status='#(bash -c ~/bashrc-cg/shellscripts/network.sh)'
tm_session="#[fg=$tm_fg,bg=$tm_bg_highlight,bold] $tm_network_status "
tm_win_name="#(bash -c '~/bashrc-cg/shellscripts/iconize-string.sh #W')"

tm_left_section="$tm_session "
tm_right_section="#[fg=$tm_fg,bg=$tm_bg_highlight] $tm_datetime $tm_battery_status "

set -g status-left "$tm_left_section"
set -g status-right "$tm_right_section"

setw -g window-status-activity-style "underscore,fg=$tm_fg,bg=$tm_bg_highlight"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=$tm_fg,bg=$tm_bg_highlight"

tm_win_inactive="#[default]$tm_win_name "
tm_win_active="#[fg=$tm_fg,bg=$tm_bg_highlight,bold]$tm_win_name #[fg=$tm_active_tab_pointer_bg,bg=$tm_bg_highlight]󰩔 "

setw -g window-status-format "$tm_win_inactive "
setw -g window-status-current-format "$tm_win_active"
