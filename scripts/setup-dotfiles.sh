#!/usr/bin/env bash

set -euo pipefail

home="/home/wh1le"
dotfiles_url="https://github.com/wh1le/dot-files.git"
ssh_dotfiles_url="git@github.com:wh1le/dot-files.git"
target_dir="$home/dot/files"

if [ ! -d "$target_dir" ]; then
    git clone -b linux --recurse-submodules "$dotfiles_url" "$target_dir"
    cd "$target_dir"
    git remote set-url origin "$ssh_dotfiles_url"
else
    echo "Dotfiles directory already exists, skipping clone."
fi

if [ -d "$target_dir" ]; then
    echo "Repository available. Installing..."

    cd "$target_dir"
    make link_common
    make link_linux_hypr
else
    echo "Error: Failed to clone the repository."
fi