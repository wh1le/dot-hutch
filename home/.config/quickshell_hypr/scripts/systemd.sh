#!/usr/bin/env bash
set -euo pipefail

unit_from_label() {
  echo "$1" | awk '{print $2}'
}

case "${1:-list}" in
  list)
    python3 ~/.config/quickshell/scripts/systemd-units.py
    ;;
  select|actions)
    if [[ "$1" == "actions" ]]; then
      printf '%s\n' "Status" "Restart" "Stop" "Start" "Enable" "Disable" "Logs"
      exit 0
    fi
    # select → show status
    u=$(unit_from_label "$2")
    kitty --title "systemd status" sh -c "systemctl status '$u' | less"
    ;;
  action)
    u=$(unit_from_label "$3")
    case "$2" in
      Status)  kitty --title "systemd status" sh -c "systemctl status '$u' | less" ;;
      Restart) systemctl restart "$u" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      Stop)    systemctl stop "$u" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      Start)   systemctl start "$u" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      Enable)  systemctl enable "$u" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      Disable) systemctl disable "$u" && paplay "$SOUND_THEME_PATH/completion-partial.oga" & ;;
      Logs)    kitty --title "systemd logs" sh -c "journalctl -u '$u' -n 100 --no-pager | less" ;;
    esac
    ;;
esac
