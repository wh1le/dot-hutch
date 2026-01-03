#!/usr/bin/env bash

set -eu

username="${1:?username required}"

export HOME="/home/$username"
export DOT_FILES="${2:?dot-files-path required}"

sudo ln -sfn "$DOT_FILES" /etc/nixos

sudo nixos-rebuild switch --flake "/etc/nixos#$(hostnamectl --static 2>/dev/null || hostname)"

"$DOT_FILES/scripts/deploy-home.sh" "$username"

echo "bootstrap complete"
