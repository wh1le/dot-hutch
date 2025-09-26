echo "Linking files ..."

ln -s ~/code/dot-files/files/.config/nvim ~/.config/nvim
ln -s ~/code/dot-files/files/.config/zsh ~/.config/zsh

ln -s ~/code/dot-files/files/.config/wezterm ~/.config/wezterm
ln -s ~/code/dot-files/files/.config/kitty ~/.config/kitty
# ln -s ~/code/dot-files/files/.config/alacritty ~/.config/alacritty

# Zsh
ln -s ~/code/dot-files/files/.zshrc ~/.zshrc
ln -s ~/code/dot-files/files/.zsh ~/.zsh
ln -s ~/code/dot-files/files/.dir_colors_eink ~/.dir_colors_eink

# Tmux
ln -s ~/code/dot-files/files/.tmux.conf ~/.tmux.conf
ln -s ~/code/dot-files/files/.tmux ~/.tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -s ~/code/dot-files/files/.cspell.json ~/.config/.cspell.json

# Unix
ln -s ~/code/dot-files/files/.config/rofi/ ~/.config/rofi
ln -s ~/code/dot-files/files/.config/polybar/ ~/.config/polybar
ln -s ~/code/dot-files/files/.config/gtk-3.0/ ~/.config/gtk-3.0
ln -s ~/code/dot-files/files/.config/gtk-4.0/ ~/.config/gtk-4.0
ln -s ~/code/dot-files/files/.config/autorandr/ ~/.config/autorandr
ln -s ~/code/dot-files/files/.config/neofetch/ ~/.config/neofetch
ln -s ~/code/dot-files/files/.config/picom/ ~/.config/picom
ln -s ~/code/dot-files/files/.config/sxhkd/ ~/.config/sxhkd
ln -s ~/code/dot-files/files/.config/i3/ ~/.config/i3

echo "Done."
