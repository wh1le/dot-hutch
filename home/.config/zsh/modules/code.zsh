alias code-lines='tokei --compact'

code-wipe-ruby-history() {
  local files=(
    "$HOME/.local/share/pry/pry_history"
    "$HOME/.pry_history"
    "$HOME/.irb_history"
    "$HOME/.local/share/irb/irb_history"
  )

  local f removed=0
  for f in $files; do
    if [[ -f "$f" ]]; then
      rm -f "$f" && echo "removed: $f" && ((removed++))
    fi
  done

  [[ $removed -eq 0 ]] && echo "no ruby history files found"
  return 0
}
