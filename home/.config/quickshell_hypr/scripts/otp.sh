#!/usr/bin/env bash
set -euo pipefail

export PASSWORD_STORE_DIR="$HOME/.secrets/passwords"

case "${1:-list}" in
  list)
    find "$PASSWORD_STORE_DIR" -name '*.otp.gpg' -type f -printf '%P\n' | sed 's|\.gpg$||' | sort
    ;;
  select)
    export GPG_TTY=$(tty)
    pass show "$2" >/dev/null 2>&1 || { notify-send -u critical "Pass Error" "Failed to decrypt"; exit 1; }
    otp=$(pass otp "$2" | head -n1 | tr -d '\n')
    wl-copy <<<"$otp"
    sleep 0.1
    cliphist delete-query "$otp"
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
  actions)
    printf '%s\n' "Copy OTP" "Show OTP"
    ;;
  action)
    export GPG_TTY=$(tty)
    case "$2" in
      "Copy OTP")
        pass show "$3" >/dev/null 2>&1 || { notify-send -u critical "Pass Error" "Failed to decrypt"; exit 1; }
        otp=$(pass otp "$3" | head -n1 | tr -d '\n')
        wl-copy <<<"$otp"
        sleep 0.1
        cliphist delete-query "$otp"
        paplay "$SOUND_THEME_PATH/completion-partial.oga" &
        ;;
      "Show OTP")
        otp=$(pass otp "$3" | head -1)
        notify-send "2FA" "$otp"
        ;;
    esac
    ;;
esac
