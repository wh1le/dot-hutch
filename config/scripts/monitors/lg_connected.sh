#!/usr/bin/env bash

set -euo pipefail

LG_MONITOR="DP-1" # swww query

ORIENTATION="${1:-horizontal}"
DEFAULT_WALLPAPER="$HOME/dot/files/assets/black-background.jpg"

case "$ORIENTATION" in
  *rotated*)
    swww img --outputs  "$LG_MONITOR" "$DEFAULT_WALLPAPER"
  ;;
  *)
    swww img --outputs  "$LG_MONITOR" "$DEFAULT_WALLPAPER"
  ;;
esac

notify-send 'LG connected on $LG_MONITOR and settings applied'
