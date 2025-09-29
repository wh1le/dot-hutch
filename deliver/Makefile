.PHONY: link_common link_linux_i3 link_linux_hypr link_mac

link_common: ## Link common utils like tmux, neovim, zsh
	./dotbot/bin/dotbot -c ./dotbot-config/linux_common.conf.yaml
	echo "[dotbot] Common files linked"

link_linux_i3: ## Link linux i3 files
	./dotbot/bin/dotbot -c ./dotbot-config/link_linux_i3.conf.yaml
	echo "[dotbot] i3 files linked"

link_linux_hypr: ## Link linux hyprland
	./dotbot/bin/dotbot -c ./dotbot-config/link_linux_hypr.conf.yaml
	echo "[dotbot] hypr files linked"

link_mac: ## Link mac configuration
	./dotbot/bin/dotbot -c ./dotbot-config/mac.conf.yaml
	echo "[dotbot] mac files linked"
