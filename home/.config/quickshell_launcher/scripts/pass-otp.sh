#!/usr/bin/env bash
set -euo pipefail

export PASSWORD_STORE_DIR="$HOME/.secrets/passwords"
export GPG_TTY=$(tty)

choice="$1"
[[ -z "${choice:-}" ]] && exit 1

if ! pass show "$choice" >/dev/null 2>&1; then
  notify-send -u critical "Pass Error" "Failed to decrypt $choice"
  exit 1
fi

otp=$(pass otp "$choice" | head -n1 | tr -d '\n')

{ copyq disable >/dev/null 2>&1; copyq copy - <<<"$otp"; copyq enable >/dev/null 2>&1; }
sleep 0.1

paplay "$SOUND_THEME_PATH/completion-partial.oga" &
