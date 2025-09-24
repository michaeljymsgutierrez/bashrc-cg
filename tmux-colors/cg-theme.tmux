# Constant colors
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

# Section contents
display_time='#(bash -c ~/bashrc-cg/shellscripts/time.sh)'
display_date='#(bash -c ~/bashrc-cg/shellscripts/date.sh)'
display_datetime="$display_time $display_date"
display_battery_status='#(bash -c ~/bashrc-cg/shellscripts/battery.sh)'
display_network_status='#(bash -c ~/bashrc-cg/shellscripts/network.sh)'

display_left_section_content="$display_network_status "
display_right_section_content="#[fg=$pane_text_color,bg=$pane_background_color] $display_datetime $display_battery_status "

window_name="#(bash -c '~/bashrc-cg/shellscripts/iconize-string.sh #W')"

display_left_section="$display_left_section_content "
display_right_section="$display_right_section_content"

set -g status-left "$display_left_section"
set -g status-right "$display_right_section"

setw -g window-status-activity-style "underscore,fg=$pane_text_color,bg=$pane_background_color"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=$pane_text_color,bg=$pane_background_color"

# Window Format
inactive_window_format="#[default]$window_name "
active_window_format="#[fg=$pane_text_color,bg=$pane_background_color,bold]$window_name #[fg=$tab_pointer_background_color,bg=$pane_background_color]󰩔  "

setw -g window-status-format "$inactive_window_format "
setw -g window-status-current-format "$active_window_format"
