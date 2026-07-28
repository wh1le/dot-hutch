#!/usr/bin/env bash
set -euo pipefail

case "${1:-list}" in
  list)
    grep -E '^profile ' ~/.config/kanshi/config | awk '{print $2}' | grep "^$(hostname)" || true
    ;;
  select)
    kanshictl switch "$2" && paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
esac
