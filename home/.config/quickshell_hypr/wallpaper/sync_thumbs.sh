#!/usr/bin/env bash
# Background thumbnail sync for local wallpapers.
# Usage: sync_thumbs.sh <base_dir>
# Scans default/ and fav/ subdirs, generates missing thumbs.

set -euo pipefail

BASE_DIR="$1"
THUMBS="$HOME/.cache/wallpaper_picker/thumbs"

[ ! -d "$BASE_DIR" ] && exit 1
mkdir -p "$THUMBS"

if command -v magick &>/dev/null; then CMD="magick"; else CMD="convert"; fi

# Fav wallpapers prefixed with "AAA_" so they sort first
for file in "$BASE_DIR"/fav/*.{jpg,jpeg,png,webp}; do
    [ -f "$file" ] || continue
    fname="AAA_$(basename "$file")"
    [ -f "$THUMBS/$fname" ] && continue
    $CMD "$file" -resize x420 -quality 70 "$THUMBS/$fname" 2>/dev/null || true
done

for file in "$BASE_DIR"/default/*.{jpg,jpeg,png,webp}; do
    [ -f "$file" ] || continue
    fname="$(basename "$file")"
    [ -f "$THUMBS/$fname" ] && continue
    $CMD "$file" -resize x420 -quality 70 "$THUMBS/$fname" 2>/dev/null || true
done

# Clean orphaned thumbs whose source no longer exists in either dir
for thumb in "$THUMBS"/*; do
    [ -f "$thumb" ] || continue
    fname="$(basename "$thumb")"
    # Skip search-downloaded thumbs (prefixed with ddg_)
    [[ "$fname" == ddg_* ]] && continue
    # Strip fav prefix for lookup
    clean="${fname#AAA_}"
    [ -f "$BASE_DIR/default/$clean" ] || [ -f "$BASE_DIR/fav/$clean" ] || [ -f "$BASE_DIR/default/$fname" ] || rm -f "$thumb"
done
