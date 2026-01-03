#!/usr/bin/env bash

set -eu

export HOME="/home/${1:?username required}"
export DOT_FILES="${HOME}/dot/nix-public"

home_dirs=(
  Documents
  Videos
  Music
  Cloud
  code
  Projects
  Virtualization
)

create_home_defaults() {
  for dir in "${home_dirs[@]}"; do
    mkdir -p "$HOME/$dir"
  done

  echo "home directories created: ${home_dirs[*]}"
}

create_home_defaults

$HOME/dot/nix-public/scripts/linking/deploy-scripts.sh "$HOME/dot/nix-public/home/.local/bin/public" "$HOME/.local/bin/public"
$HOME/dot/nix-public/scripts/linking/deploy-scripts.sh "$HOME/dot/nix-public/home/.local/share/darkman" "$HOME/.local/share/darkman"

$HOME/dot/nix-public/scripts/linking/deploy-xdg-config.sh "$DOT_FILES/home/.config" "$HOME/.config"
$HOME/dot/nix-public/scripts/linking/clone-submodules.sh "$DOT_FILES"
