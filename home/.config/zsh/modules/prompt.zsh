if [[ "$(uname -s)" == "Darwin" ]]; then
	source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
else
	if [[ -f "$HOME/.nix-profile/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
		source "$HOME/.nix-profile/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme"
	elif [[ -f /run/current-system/sw/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
		source /run/current-system/sw/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
	elif [[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
		source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
	fi
fi

[[ ! -f ~/.config/zsh/modules/powerlevel10k.zsh ]] || source ~/.config/zsh/modules/powerlevel10k.zsh
