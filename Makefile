.PHONY: lint mac mac-check

lint:
	nix run nixpkgs#nixfmt -- --check $(shell git ls-files '*.nix')
	nix run nixpkgs#statix -- check .
	nix run nixpkgs#deadnix -- --fail $(shell git ls-files '*.nix')

mac:
	./scripts/deploy-on-mac

mac-check:
	nix eval .#darwinConfigurations.mac.system.drvPath