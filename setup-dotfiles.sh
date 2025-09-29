#!/usr/bin/sh

set -e

home="/home/wh1le"
dotfiles_url="https://github.com/wh1le/dot-files.git"
ssh_dotfiles_url="git@github.com:wh1le/dot-files.git"
target_dir="$home/dot/files"

if [ -d "$home" ]; then
    echo "Starting dotfiles setup for user wh1le..."
    
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
        make link_linux_i3
    else
        echo "Error: Failed to clone the repository."
    fi
else
    echo "User home directory $home does not exist, skipping dotfiles setup."
fi