#!/usr/bin/env bash

set -eu

export HOME="/home/${1:?username required}"
export DOT_FILES="${HOME}/Code/dot-hutch"

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

$HOME/Code/dot-hutch/scripts/linking/deploy-scripts.sh "$HOME/Code/dot-hutch/home/.local/bin/public" "$HOME/.local/bin/public"
$HOME/Code/dot-hutch/scripts/linking/deploy-scripts.sh "$HOME/Code/dot-hutch/home/.local/share/darkman" "$HOME/.local/share/darkman"

$HOME/Code/dot-hutch/scripts/linking/link-xdg-config.sh "$DOT_FILES/home/.config" "$HOME/.config"
$HOME/Code/dot-hutch/scripts/linking/clone-submodules.sh "$DOT_FILES"
