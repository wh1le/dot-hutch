#!/usr/bin/env bash
set -euo pipefail

FILE="$HOME/.sync/quickcopy.txt"

case "${1:-list}" in
  list)
    cut -d'|' -f1 "$FILE" | sed 's/ *$//'
    ;;
  select)
    value=$(grep "^${2} |" "$FILE" | sed 's/^[^|]*| *//')
    echo -n "$value" | copyq copy -
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
esac
