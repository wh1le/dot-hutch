#!/usr/bin/env bash
# Universal clipboard copy: x11 / mac / wayland
if command -v xclip >/dev/null 2>&1; then
  exec xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
  exec xsel --clipboard --input
elif command -v pbcopy >/dev/null 2>&1; then
  exec pbcopy
elif [ "$XDG_SESSION_TYPE" = "wayland" ] && command -v wl-copy >/dev/null 2>&1; then
  exec wl-copy
else
  cat >/dev/null
fi
