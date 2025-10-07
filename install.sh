#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(pwd)"

# Main
# ~/.config/alacritty: ../../config/alacritty
# ~/.config/kitty: ../../config/kitty
# ~/.config/wezterm: ../../config/wezterm
# ~/.config/zsh: ../../config/zsh
# ~/.config/tmux: ../../config/tmux
# ~/.config/nvim: ../../config/nvim
# ~/.config/scripts: ../../config/scripts

ln -sfn "$DOTFILES_DIR/zprofile/.zprofile"    ~/.zprofile
ln -sfn "$DOTFILES_DIR/config/dunst"          ~/.config/dunst
ln -sfn "$DOTFILES_DIR/config/hypr"           ~/.config/hypr
ln -sfn "$DOTFILES_DIR/config/nix"            ~/.config/nix
ln -sfn "$DOTFILES_DIR/config/wal"            ~/.config/wal
ln -sfn "$DOTFILES_DIR/config/waybar"         ~/.config/waybar
ln -sfn "$DOTFILES_DIR/config/wofi"           ~/.config/wofi
ln -sfn "$DOTFILES_DIR/config/nix-search-tv"  ~/.config/nix-search-tv
ln -sfn "$DOTFILES_DIR/config/deployed"       ~/.config/deployed
