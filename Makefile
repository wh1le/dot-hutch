.PHONY: lint mac mac-check darwin-check-build darwin-dump-packages

lint:
	nix run nixpkgs#nixfmt -- --check $(shell git ls-files '*.nix')
	nix run nixpkgs#statix -- check .
	nix run nixpkgs#deadnix -- --fail $(shell git ls-files '*.nix')

mac:
	./scripts/deploy-on-mac

darwin-check-build:
	nix eval .#darwinConfigurations.mac.system.drvPath

darwin-dump-packages:
  brew bundle dump --file="$PWD/Brewfile" --force
