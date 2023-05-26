#!/usr/bin/env bash

# create a new window
# $1 - name of the window
# $2 - script / location of the script

tmux new-window -n "$1"

# Run your ommand in the new window
tmux send-keys -t "$1" "sh $2; tmux wait-for -S cht-sheet-exit-signal" Enter

# Switch to the new window
tmux select-window -t "$1"

# Wait for the pane to exit and close the window
tmux wait-for cht-sheet-exit-signal
tmux kill-window -t "$1"

