#!/usr/bin/env bash
dir="$1"
key="$2"

eval "$(hyprctl activewindow -j | jq -r '@sh "class=\(.class) title=\(.title) pid=\(.pid)"')"

if [[ "$class" == "kitty" && ( "$title" == tmux:* || "$title" == *nvim* || "$title" == *vim* ) ]]; then
    kitty @ --to "unix:/tmp/kitty-${pid}" send-key --match recent:0 "ctrl+$key" >/dev/null 2>&1
else
    hyprctl dispatch movefocus "$dir" >/dev/null 2>&1
fi
