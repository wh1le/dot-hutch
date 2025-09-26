#!/usr/bin/env bash
dir="$1"
[ -d "$dir" ] || exit 0
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
  printf " %s" "$branch"
  exit 0
fi
hash=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
[ -n "$hash" ] && printf " %s" "$hash"
