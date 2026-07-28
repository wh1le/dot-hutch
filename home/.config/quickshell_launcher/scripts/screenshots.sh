#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/screenshots"

# Copy a file to the clipboard so file managers (nautilus/etc) paste it as a
# real file. Sets both text/uri-list and the GNOME file-copy target.
copy_file() {
  local f="$1" uri="file://$1"
  copyq copy \
    text/uri-list "$uri"$'\n' \
    x-special/gnome-copied-files "copy"$'\n'"$uri" \
    text/plain "$uri"
}

case "${1:-list}" in
  list)
    python3 ~/.config/quickshell_launcher/scripts/screenshots.py
    ;;
  select)
    file="${2##* | }"
    copy_file "$file"
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
  actions)
    printf '%s\n' "Copy" "Open" "Delete"
    ;;
  action)
    file="${3##* | }"
    case "$2" in
      Copy)   copy_file "$file"; paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      Open)   setsid imv "$file" >/dev/null 2>&1 & ;;
      Delete) rm "$file" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
    esac
    ;;
esac
