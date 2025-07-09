echo "Linking files ..."
# cp -rf ../files/.config ~/
ln -s ~/code/dot-files/files/.config/nvim ~/.config/nvim
ln -s ~/code/dot-files/files/.config/wezterm/.wezterm.lua ~/.config/wezterm/wezterm.lua
ln -s ~/code/dot-files/files/.zshrc ~/.zshrc
ln -s ~/code/dot-files/files/.dir_colors_eink ~/.dir_colors_eink
# cp -rf ../files/.zsh ~/
# cp ../files/.tmux.conf ~/
echo "Done."
