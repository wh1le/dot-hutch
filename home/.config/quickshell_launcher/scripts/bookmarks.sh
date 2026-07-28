#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"

case "${1:-list}" in
  list)
    "$SCRIPT_DIR/firefox-bookmarks.sh"
    ;;
  select)
    url="${2##* | }"
    xdg-open "$url"
    ;;
  actions)
    printf '%s\n' "Open" "Copy URL"
    ;;
  action)
    url="${3##* | }"
    case "$2" in
      Open)     xdg-open "$url" ;;
      "Copy URL") echo -n "$url" | copyq copy - ;;
    esac
    ;;
esac
