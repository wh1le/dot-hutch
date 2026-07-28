#!/usr/bin/env bash
set -euo pipefail

export PASSWORD_STORE_DIR="$HOME/.secrets/passwords"

list_entries() {
  find "$PASSWORD_STORE_DIR" -name '*.gpg' -not -name '*.otp.gpg' -type f -printf '%P\n' | sed 's|\.gpg$||' | sort
}

case "${1:-list}" in
  list)
    list_entries
    ;;
  select)
    export GPG_TTY=$(tty)
    pw=$(pass show "$2" | head -n1 | tr -d '\n')
    { copyq disable >/dev/null 2>&1; copyq copy - <<<"$pw"; copyq enable >/dev/null 2>&1; }
    sleep 0.1
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
  actions)
    printf '%s\n' "Copy password" "Copy OTP" "Show"
    ;;
  action)
    export GPG_TTY=$(tty)
    case "$2" in
      "Copy password")
        pw=$(pass show "$3" | head -n1 | tr -d '\n')
        { copyq disable >/dev/null 2>&1; copyq copy - <<<"$pw"; copyq enable >/dev/null 2>&1; }
        sleep 0.1
        paplay "$SOUND_THEME_PATH/completion-partial.oga" &
        ;;
      "Copy OTP")
        otp=$(pass otp "$3" 2>/dev/null | tr -d '\n')
        { copyq disable >/dev/null 2>&1; copyq copy - <<<"$otp"; copyq enable >/dev/null 2>&1; }
        paplay "$SOUND_THEME_PATH/completion-partial.oga" &
        ;;
      "Show")
        notify-send "pass" "$(pass show "$3" | head -5)"
        ;;
    esac
    ;;
esac
