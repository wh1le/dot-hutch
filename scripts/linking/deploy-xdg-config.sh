USER_CONFIG_FOLDER="${1:-$HOME/.config}"
SOURCE_FROM="${2:?Error: provide source from as a second argument required}"

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

mkdir -p "$USER_CONFIG_FOLDER"

for item in "$SOURCE_FROM"/*; do
  name=$(basename "$item")
  target="$USER_CONFIG_FOLDER/$name"

  fix_existing_link "$target" "$item" || continue

  ln -s "$item" "$target"

  echo "linked: $name"
done
