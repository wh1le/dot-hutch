.PHONY: test switch

test: ## Load test build
	sudo nixos-rebuild test --flake .#default

switch: ## Switch to new version
	sudo nixos-rebuild switch --flake .#default

launch-debug-vm: ## Launch OS in WM
	result/bin/run-wh1le-vm-debug-vm -m 16384 -smp 6 #--display sdl
