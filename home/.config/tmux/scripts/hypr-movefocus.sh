#!/usr/bin/env bash
dir="$1"
active=$(hyprctl activewindow -j)
count=$(hyprctl clients -j | jq --argjson a "$active" --arg d "$dir" '
  ($a.at[0]) as $ax | ($a.at[1]) as $ay | ($a.size[0]) as $aw | ($a.size[1]) as $ah |
  [.[] | select(.workspace.id == $a.workspace.id and .mapped and (.hidden | not) and .address != $a.address and (
    if $d == "l" then .at[0] + .size[0] <= $ax
    elif $d == "r" then .at[0] >= $ax + $aw
    elif $d == "u" then .at[1] + .size[1] <= $ay
    else .at[1] >= $ay + $ah end
  ))] | length')
[ "$count" -gt 0 ] && hyprctl dispatch movefocus "$dir" >/dev/null 2>&1
exit 0
