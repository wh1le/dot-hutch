.PHONY: link_common link_linux_i3 link_linux_hypr link_mac

link_common: ## Link common utils like tmux, neovim, zsh
	./dotbot/bin/dotbot -c ./dotbot-config/linux_common.conf.yaml

link_linux_i3: ## Link linux i3 files
	./dotbot/bin/dotbot -c ./dotbot-config/link_linux_i3.conf.yaml

link_linux_hypr: ## Link linux hyprland
	./dotbot/bin/dotbot -c ./dotbot-config/link_linux_hypr.conf.yaml

link_mac: ## Link mac configuration
	./dotbot/bin/dotbot -c ./dotbot-config/mac.conf.yaml
