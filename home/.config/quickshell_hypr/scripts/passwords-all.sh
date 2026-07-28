#!/usr/bin/env bash
set -euo pipefail

export PASSWORD_STORE_DIR="$HOME/.secrets/passwords"

case "${1:-list}" in
  list)
    find "$PASSWORD_STORE_DIR" -name '*.gpg' -type f -printf '%P\n' | sed 's|\.gpg$||' | sort
    ;;
  select|actions|action)
    # Delegate to passwords.sh for shared logic
    exec ~/.config/quickshell/scripts/passwords.sh "$@"
    ;;
esac
