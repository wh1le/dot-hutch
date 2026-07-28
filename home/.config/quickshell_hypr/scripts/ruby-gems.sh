#!/usr/bin/env bash
set -euo pipefail

preview_dir="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell/fzf-source/ruby-gems-previews"
mkdir -p "$preview_dir"

format_preview() {
  local json="$1"
  local name ver authors info homepage src downloads license
  name=$(printf '%s' "$json" | jq -r '.name // empty')
  [[ -z "$name" ]] && return
  ver=$(printf '%s' "$json" | jq -r '.version // "?"')
  authors=$(printf '%s' "$json" | jq -r '.authors // "?"')
  info=$(printf '%s' "$json" | jq -r '.info // ""' | head -3)
  homepage=$(printf '%s' "$json" | jq -r '.homepage_uri // empty')
  src=$(printf '%s' "$json" | jq -r '.source_code_uri // empty')
  downloads=$(printf '%s' "$json" | jq -r '.downloads // 0')
  license=$(printf '%s' "$json" | jq -r '.licenses // [] | join(", ")')

  printf '%s (%s)\n' "$name" "$ver"
  printf '    Author: %s\n' "$authors"
  [[ -n "$license" ]] && printf '    License: %s\n' "$license"
  [[ -n "$homepage" ]] && printf '    Homepage: %s\n' "$homepage"
  [[ -n "$src" ]] && printf '    Source: %s\n' "$src"
  printf '    Downloads: %s\n' "$downloads"
  [[ -n "$info" ]] && printf '\n%s\n' "$info"
}

case "${1:-list}" in
  list)
    curl -sf "https://rubygems.org/names"
    ;;
  preview)
    pf="${preview_dir}/$2"
    if [[ -f "$pf" ]]; then
      cat "$pf"
    else
      json=$(curl -sf "https://rubygems.org/api/v1/gems/$2.json" || true)
      if [[ -n "$json" ]]; then
        out=$(format_preview "$json")
        if [[ -n "$out" ]]; then
          printf '%s' "$out" > "$pf"
          printf '%s' "$out"
        fi
      fi
    fi
    ;;
  select)
    printf '%s' "$2" | wl-copy
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
  actions)
    printf '%s\n' "Copy name" "Open on RubyGems" "Open source"
    ;;
  action)
    case "$2" in
      "Copy name")
        printf '%s' "$3" | wl-copy
        paplay "$SOUND_THEME_PATH/completion-partial.oga" &
        ;;
      "Open on RubyGems")
        xdg-open "https://rubygems.org/gems/$3"
        ;;
      "Open source")
        url=$(curl -sf "https://rubygems.org/api/v1/gems/$3.json" | jq -r '.source_code_uri // empty')
        if [[ -n "$url" ]]; then
          xdg-open "$url"
        else
          notify-send "RubyGems" "No source URL found for $3"
        fi
        ;;
    esac
    ;;
esac
