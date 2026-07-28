#!/usr/bin/env bash
set -euo pipefail
STORE="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
[ -d "$STORE" ] || exit 1
find "$STORE" -name '*.gpg' -type f -printf '%P\n' | sed 's|\.gpg$||' | sort
