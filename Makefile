.PHONY: test switch

test: ## Load test build
	sudo nixos-rebuild test --flake /etc/nixos#default

switch: ## Switch to new version
	sudo nixos-rebuild switch --flake /etc/nixos#default

switch-upgrade:
	sudo nixos-rebuild switch --flake /etc/nixos#default --upgrade

# launch-debug-vm: ## Launch OS in WM
# 	result/bin/run-wh1le-vm-debug-vm -m 16384 -smp 6 #--display sdl
