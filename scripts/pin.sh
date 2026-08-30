#!/usr/bin/env bash
# Hook handler (window-resized): client/terminal resizes scale panes
# proportionally, growing sidebar/mirror panes past their set width. Snap
# every agents-mon pane back (covers both single-sidebar and mirror mode).
if [ "$(tmux show-option -gqv @agents-mon-compact)" = 1 ]; then
  w="$(tmux show-option -gqv @agents-mon-compact-width)"
  w="${w:-16}"
else
  w="$(tmux show-option -gqv @agents-mon-width)"
  w="${w:-30}"
fi
tmux list-panes -a -F '#{pane_id}	#{pane_title}' 2>/dev/null |
  awk -F'\t' '$2 == "agents-mon" { print $1 }' |
  while read -r p; do
    tmux resize-pane -t "$p" -x "$w" 2>/dev/null
  done
exit 0
