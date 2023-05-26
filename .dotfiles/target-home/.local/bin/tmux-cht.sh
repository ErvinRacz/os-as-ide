#!/usr/bin/env bash

selected=`cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww -n cheatsheet bash -c "curl --silent cht.sh/$selected/$query | less -R"
else
    tmux neww -n cheatsheet bash -c "curl -s cht.sh/$selected~$query | less -R"
fi
