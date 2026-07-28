#!/usr/bin/env bash
set -euo pipefail
export PASSWORD_STORE_DIR="$HOME/.secrets/passwords"
find "$PASSWORD_STORE_DIR" -name '*.otp.gpg' -type f -printf '%P\n' | sed 's|\.gpg$||' | sort
