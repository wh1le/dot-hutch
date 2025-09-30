#!/usr/bin/env bash

set -euo pipefail

# Username validation
[ $# -ge 1 ] || { echo "User name is missing, Usage: $0 <username>"; exit 1; }

userName=$1
home="/home/${userName}"
dotfiles_url="https://github.com/wh1le/dot-files.git"
ssh_dotfiles_url="git@github.com:wh1le/dot-files.git"
target_dir="$home/dot/files"

if [ ! -d "$target_dir" ]; then
    git clone -b linux --recurse-submodules "$dotfiles_url" "$target_dir" | tee -a /tmp/git_output.log
    cd "$target_dir"
    # git remote set-url origin "$ssh_dotfiles_url"
else
    echo "Dotfiles directory already exists, skipping clone."
fi

if [ -d "$target_dir" ]; then
    echo "Repository available. Installing..."

    cd "$target_dir"
    make link_common | tee -a /tmp/git_output.log
    make link_linux_hypr | tee -a /tmp/git_output.log
else
    echo "Error: Failed to clone the repository."
fi
