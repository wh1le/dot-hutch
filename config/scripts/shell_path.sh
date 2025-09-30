#!/usr/bin/bash env

is_nixos() {
  if [ -r /etc/os-release ]; then
    . /etc/os-release
    [ "${ID:-}" = "nixos" ] && return 0
  fi
  command -v nixos-version >/dev/null 2>&1 && return 0
  [ -e /etc/NIXOS ] || [ -d /nix/var/nix/profiles/system ] || [ -x /run/current-system/sw/bin/nixos-version ]
}

# example
if is_nixos; then
  echo "NixOS"
else
  echo "Not NixOS"
fi
