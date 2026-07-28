#!/usr/bin/env bash
# Extract Firefox browsing history from the default profile.
# Auto-detects profile path from profiles.ini.
# Output: "title | url" per line, sorted by most recent visit.

set -euo pipefail

FF_DIR="$HOME/.mozilla/firefox"
PROFILES_INI="$FF_DIR/profiles.ini"

[ -f "$PROFILES_INI" ] || exit 1

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

if [ -z "$PROFILE_PATH" ]; then
  for d in "$FF_DIR"/*.default*; do
    [ -f "$d/places.sqlite" ] && PROFILE_PATH="$(basename "$d")" && break
  done
fi

[ -z "$PROFILE_PATH" ] && exit 1

DB="$FF_DIR/$PROFILE_PATH/places.sqlite"
[ -f "$DB" ] || exit 1

TMP=$(mktemp)
cp "$DB" "$TMP"

sqlite3 "$TMP" "SELECT p.title || ' | ' || p.url FROM moz_historyvisits h JOIN moz_places p ON h.place_id = p.id WHERE p.title IS NOT NULL AND p.title != '' GROUP BY p.url ORDER BY MAX(h.visit_date) DESC LIMIT 5000"

rm -f "$TMP"
