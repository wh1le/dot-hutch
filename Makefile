.PHONY: build launch-vm

build: ## Build virtual OS for WM
	nix build .#nixosConfigurations.hyprland-vm-desktop.config.system.build.vm

launch-vm: ## Launch OS in WM
	SDL_VIDEODRIVER=x11 result/bin/run-wh1le-vm-vm -m 4096 -smp 4 --display sdl,gl=on
	# __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json \
	# 															 SDL_VIDEODRIVER=wayland \
	# 															 result/bin/run-wh1le-vm-vm -m 4096 -smp 4 --display sdl,gl=on