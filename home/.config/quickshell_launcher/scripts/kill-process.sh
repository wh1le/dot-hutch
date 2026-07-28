#!/usr/bin/env bash
set -euo pipefail

case "${1:-list}" in
  list)
    python3 ~/.config/quickshell_launcher/scripts/processes.py
    ;;
  select)
    pid="${2%% *}"
    kill "$pid" && paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
  actions)
    printf '%s\n' "Kill (SIGTERM)" "Force kill (SIGKILL)" "Copy PID"
    ;;
  action)
    pid="${3%% *}"
    case "$2" in
      "Kill (SIGTERM)")      kill "$pid" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      "Force kill (SIGKILL)") kill -9 "$pid" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      "Copy PID")            echo -n "$pid" | copyq copy - ;;
    esac
    ;;
esac
