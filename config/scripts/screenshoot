#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

mode="${1:-full}"
case "$mode" in
  full)   scrot "$FILE" ;;
  window) scrot -u "$FILE" ;;
  select) scrot -s "$FILE" ;;
  *) echo "usage: $0 {full|window|select}" >&2; exit 2 ;;
esac

xclip -selection clipboard -t image/png -i "$FILE"
notify-send -a scrot "Screenshot saved + copied" "$FILE" -i "$FILE"