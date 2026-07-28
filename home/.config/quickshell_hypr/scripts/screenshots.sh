#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/screenshots"

case "${1:-list}" in
  list)
    python3 ~/.config/quickshell/scripts/screenshots.py
    ;;
  select)
    file="${2##* | }"
    wl-copy --type text/uri-list "file://$file"
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
  actions)
    printf '%s\n' "Copy" "Open" "Delete"
    ;;
  action)
    file="${3##* | }"
    case "$2" in
      Copy)   wl-copy --type text/uri-list "file://$file"; paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      Open)   setsid xdg-open "$file" >/dev/null 2>&1 & ;;
      Delete) rm "$file" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
    esac
    ;;
esac
