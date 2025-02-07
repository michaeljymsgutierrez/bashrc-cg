pane_text_color="#f8f1ff"
pane_background_color="#222222"
active_pane_border_color="#fde466"
inactive_pane_border_color="#444444"
tab_pointer_background_color="#fde466"

set -g mode-style "fg=$pane_text_color,bg=$inactive_pane_border_color"

set -g message-style "fg=$pane_text_color,bg=$pane_background_color"
set -g message-command-style "fg=$pane_text_color,bg=$inactive_pane_border_color"

set -g pane-border-style "fg=$inactive_pane_border_color"
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
left_section_content="#[fg=$pane_text_color,bg=$pane_background_color,bold] $tm_network_status "
right_section_content="#[fg=$pane_text_color,bg=$pane_background_color] $tm_datetime $tm_battery_status "
window_name="#(bash -c '~/bashrc-cg/shellscripts/iconize-string.sh #W')"

left_section="$left_section_content "
right_section="$right_section_content"

set -g status-left "$left_section"
set -g status-right "$right_section"

setw -g window-status-activity-style "underscore,fg=$pane_text_color,bg=$pane_background_color"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=$pane_text_color,bg=$pane_background_color"

tm_win_inactive="#[default]$window_name "
tm_win_active="#[fg=$pane_text_color,bg=$pane_background_color,bold]$window_name #[fg=$tab_pointer_background_color,bg=$pane_background_color]󰩔 "

setw -g window-status-format "$tm_win_inactive "
setw -g window-status-current-format "$tm_win_active"
