.PHONY: link_common link_linux_i3 link_linux_hypr link_mac

link_common: ## Link common utils like tmux, neovim, zsh
	./deliver/dotbot/bin/dotbot -c ./deliver/dotbot-config/linux_common.conf.yaml
	echo "[dotbot] Common files linked"

link_linux_i3: ## Link linux i3 files
	./deliver/dotbot/bin/dotbot -c ./deliver/dotbot-config/linux_i3.conf.yaml
	echo "[dotbot] i3 files linked"

link_linux_hypr: ## Link linux hyprland
	./deliver/dotbot/bin/dotbot -c ./deliver/dotbot-config/linux_hyprland.conf.yaml
	echo "[dotbot] hypr files linked"

link_mac: ## Link mac configuration
	./deliver/dotbot/bin/dotbot -c ./deliver/dotbot-config/mac.conf.yaml
	echo "[dotbot] mac files linked"
