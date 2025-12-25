#!/usr/bin/env bash

bg_color=$(kitty @ get-colors | grep '^background' | awk '{print $2}')

if [[ "$bg_color" == "#ffffff" ]]; then
  tmux source-file ~/.config/tmux/colors/eink.conf
else
  tmux source-file ~/.config/tmux/colors/rgb.conf
fi
