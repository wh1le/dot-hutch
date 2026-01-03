#!/usr/bin/env bash

set -eu

src="${1:?source path required}"
dest="${2:?destination path required}"

mkdir -p "$(dirname "$dest")"
ln -sfn "$src" "$dest"
echo "linked: $src -> $dest"
