.PHONY: build launch-vm

build: ## Build virtual OS for WM
	nix build .#nixosConfigurations.hyprland-vm-desktop.config.system.build.vm

launch-debug-vm: ## Launch OS in WM
	result/bin/run-wh1le-vm-debug-vm -m 16384 -smp 6 #--display sdl
