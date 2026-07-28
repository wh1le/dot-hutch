#!/usr/bin/env bash
# Extract Firefox bookmarks from the default profile.
# Auto-detects profile path from profiles.ini.
# Output: "title | url" per line, suitable for fzf.

set -euo pipefail

FF_DIR="$HOME/.mozilla/firefox"
PROFILES_INI="$FF_DIR/profiles.ini"

[ -f "$PROFILES_INI" ] || exit 1

# Find the default profile path
PROFILE_PATH=""
current_path=""
while IFS='=' read -r key value; do
  key="${key%%[[:space:]]}"
  value="${value##[[:space:]]}"
  case "$key" in
    Path) current_path="$value" ;;
    Default)
      if [ "$value" = "1" ] && [ -n "$current_path" ]; then
        PROFILE_PATH="$current_path"
        break
      fi
      ;;
    "[Profile"*) current_path="" ;;
  esac
done < "$PROFILES_INI"

# Fallback: first *.default* dir with places.sqlite
if [ -z "$PROFILE_PATH" ]; then
  for d in "$FF_DIR"/*.default*; do
    [ -f "$d/places.sqlite" ] && PROFILE_PATH="$(basename "$d")" && break
  done
fi

[ -z "$PROFILE_PATH" ] && exit 1

DB="$FF_DIR/$PROFILE_PATH/places.sqlite"
[ -f "$DB" ] || exit 1

# Copy to avoid lock conflicts with running Firefox
TMP=$(mktemp)
cp "$DB" "$TMP"

sqlite3 "$TMP" "SELECT b.title || ' | ' || p.url FROM moz_bookmarks b JOIN moz_places p ON b.fk = p.id WHERE b.type = 1 AND b.title IS NOT NULL AND b.title != '' ORDER BY b.lastModified DESC"

rm -f "$TMP"
