files-clean-empty-dir() {
  echo -n "Delete all empty dirs in $(pwd)? [y/N] "
  read confirm
  [[ "$confirm" == [yY] ]] || {
    echo "Aborted."
    return
  }
  find . -type d -empty -delete
}

files-flatten() {
  echo -n "Flatten all files into $(pwd)? [y/N] "
  read confirm
  [[ "$confirm" == [yY] ]] || {
    echo "Aborted."
    return
  }
  find ./ -type f -exec mv -t ./ {} +
}

files-sanitize() {
  local target="${1:-.}"
  local renames=()
  local entries=()
  local dir name base ext new file

  while IFS= read -r -d '' e; do entries+=("$e"); done < <(find "$target" -mindepth 1 -depth -print0)

  for file in "${entries[@]}"; do
    dir="${file:h}"
    name="${file:t}"

    # Remove macOS junk
    if [[ "$name" == ._* || "$name" == .DS_Store ]]; then
      rm -- "$file"
      echo "Removed macOS junk: $file"
      continue
    fi

    if [[ -f "$file" ]]; then
      ext="${name:e}"
      base="${name:r}"
    else
      ext=""
      base="$name"
    fi

    new="$base"

    # Strip YouTube IDs (exactly 11 chars, no spaces)
    new=$(echo "$new" | sed 's/ \[[a-zA-Z0-9_-]\{11\}\]$//')
    # Strip non-letter/number/basic-punctuation unicode (keeps accented letters)
    [[ "$new" == *[^[:ascii:]]* ]] && new=$(echo "$new" | perl -CSD -pe "s/[^\p{L}\p{N} _.,'\''&()\-]//g")
    # Collapse multiple spaces / trim
    new="${new//  ##/ }"
    new="${${new##[_ ]##}%%[_ ]##}"

    [[ -n "$ext" ]] && new="$new.$ext"
    [[ "$new" == "$name" ]] && continue

    renames+=("$file" "$dir/$new")
  done

  if ((${#renames} == 0)); then
    echo "Nothing to rename."
    return
  fi

  echo "Proposed renames:"
  for ((i = 1; i <= ${#renames}; i += 2)); do
    printf '\e[31m- %s\e[0m\n\e[32m+ %s\e[0m\n\n' "${renames[$i]:t}" "${renames[$i + 1]:t}"
  done

  echo -n "Apply? [y/N] "
  read confirm
  [[ "$confirm" == [yY] ]] || {
    echo "Aborted."
    return
  }

  for ((i = 1; i <= ${#renames}; i += 2)); do
    mv -- "$renames[$i]" "$renames[$i + 1]"
    echo "Renamed: ${renames[$i]:t} -> ${renames[$i + 1]:t}"
  done
}
