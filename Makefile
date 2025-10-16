.PHONY: test
test: ## Load test build
	sudo nixos-rebuild test --flake /etc/nixos#default

.PHONY: switch
switch: ## Switch to new version
	sudo nixos-rebuild switch --flake /etc/nixos#default

.PHONY: switch-upgrade
switch-upgrade:
	sudo nixos-rebuild switch --flake /etc/nixos#default --upgrade

# launch-debug-vm: ## Launch OS in WM
# 	result/bin/run-wh1le-vm-debug-vm -m 16384 -smp 6 #--display sdl

.PHONY: clean
clean:
	sudo nix-collect-garbage -d
