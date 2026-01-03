fix_existing_link() {
  local target=$1
  local item=$2

  if [ -L "$target" ]; then

    local current="$(readlink -- "$target")"

    if [ "$current" = "$item" ]; then
      return 1
    else
      rm -f -- "$target"

      echo "removed outdated link: $target"
    fi
  elif [ -e "$target" ]; then
    rm -rf -- "$target"

    echo "directory detected: $target, deleting..."
  fi

  return 0
}

link_xdg_config() {
  mkdir -p "$XDG_CONFIG_DEST"

  for item in "$XDG_CONFIG_SRC"/*; do
    local name=$(basename "$item")
    local target="$XDG_CONFIG_DEST/$name"

    fix_existing_link "$target" "$item" || continue

    ln -s "$item" "$target"

    echo "linked: $name"
  done
}
