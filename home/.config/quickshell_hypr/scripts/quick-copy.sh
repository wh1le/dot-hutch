#!/usr/bin/env bash
set -euo pipefail

FILE="$HOME/.secrets/quickshell_quick.txt"

case "${1:-list}" in
  list)
    cut -d'|' -f1 "$FILE" | sed 's/ *$//'
    ;;
  select)
    value=$(grep "^${2} |" "$FILE" | sed 's/^[^|]*| *//')
    echo -n "$value" | wl-copy
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
esac
